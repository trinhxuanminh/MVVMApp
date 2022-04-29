//
//  MovieService.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 19/04/2022.
//

import RxSwift
import RxCocoa
import CoreData

protocol MovieRepositoryProtocol {
    func loadList(input: MovieListInput) -> Observable<MovieListOutput>
    
    func fetchFavorite() -> Observable<[Movie]>
    
    func isFavorite(_ movie: Movie) -> Bool
    
    func addFavorite(_ movie: Movie)
    
    func deleteFavorite(_ movie: Movie)
}

class MovieRepository: APIService, MovieRepositoryProtocol {
    func loadList(input: MovieListInput) -> Observable<MovieListOutput> {
        return self.request(input)
            .observe(on: MainScheduler.instance)
            .share(replay: 1, scope: .whileConnected)
    }
    
    func loadDetail(input: MovieDetailInput) -> Observable<MovieDetailOutput> {
        return self.request(input)
            .observe(on: MainScheduler.instance)
            .map({ movieDetail in
                return MovieDetailOutput(movieDetail)
            })
            .share(replay: 1, scope: .whileConnected)
    }
    
    func fetchFavorite() -> Observable<[Movie]> {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return Observable.just([])
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = MovieEntity.fetchRequest()

        do {
            let listMovieEntity = try managedContext.fetch(request)
            let movies = listMovieEntity.map { movieEntity -> Movie in
                return self.convert_Entity_To_Movie(movieEntity)
            }
            return Observable.just(movies)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return Observable.just([])
    }

    func isFavorite(_ movie: Movie) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = MovieEntity.fetchRequest()
        
        do {
            let listMovieEntity = try managedContext.fetch(request)
            return listMovieEntity.firstIndex(where: {
                let id = $0.id
                return id == movie.id!
            }) != nil
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return false
    }

    func addFavorite(_ movie: Movie) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.insert(self.convert_Movie_To_Entity(movie, context: managedContext))
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func deleteFavorite(_ movie: Movie) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = MovieEntity.fetchRequest()
        
        do {
            let listMovieEntity = try managedContext.fetch(request)
            let movieEntity = listMovieEntity.first { movieEntity in
                return movieEntity.id == Int64(movie.id!)
            }
            guard let movieEntity = movieEntity else {
                return
            }
            managedContext.delete(movieEntity)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func convert_Movie_To_Entity(_ movie: Movie, context: NSManagedObjectContext) -> MovieEntity {
        let movieEntity = MovieEntity(context: context)
        
        movieEntity.backdrop_path = movie.backdrop_path
        movieEntity.id = Int64(movie.id ?? 0)
        movieEntity.overview = movie.overview
        movieEntity.poster_path = movie.poster_path
        movieEntity.release_date = movie.release_date
        movieEntity.title = movie.title
        movieEntity.vote_average = movie.vote_average ?? 0
        movieEntity.genre_ids = movie.genre_ids
        return movieEntity
    }
    
    private func convert_Entity_To_Movie(_ entity: MovieEntity) -> Movie {
        let json: [String: Any] = ["backdrop_path": entity.backdrop_path as Any,
                                   "id": entity.id,
                                   "overview": entity.overview as Any,
                                   "poster_path": entity.poster_path as Any,
                                   "release_date": entity.release_date as Any,
                                   "title": entity.title as Any,
                                   "vote_average": entity.vote_average,
                                   "genre_ids": (entity.genre_ids ?? []) as [Int]
        ]
        return Movie(JSON: json)!
    }
}
