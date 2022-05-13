//
//  MovieService.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 19/04/2022.
//

import RxSwift
import RxCocoa
import CoreData
import RealmSwift

protocol MovieRepositoryProtocol {
    func loadList(input: MovieListInput) -> Observable<MovieListOutput>
    func loadDetail(input: MovieDetailInput) -> Observable<MovieDetailOutput>
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
        let listObject = RealmService.shared.fetch(ofType: MovieObject.self)
        return Observable.just(listObject.map { movieObject -> Movie in
            return self.convert_Object_To_Movie(movieObject)
        })
    }

    func isFavorite(_ movie: Movie) -> Bool {
        guard let id = movie.id else {
            return false
        }
        return RealmService.shared.getById(ofType: MovieObject.self, id: id) != nil
    }

    func addFavorite(_ movie: Movie) {
        RealmService.shared.add(self.convert_Movie_To_Object(movie))
    }

    func deleteFavorite(_ movie: Movie) {
        guard let id = movie.id, let movieObject = RealmService.shared.getById(ofType: MovieObject.self, id: id) else {
            return
        }
        RealmService.shared.delete(movieObject)
    }
    
    private func convert_Movie_To_Object(_ movie: Movie) -> MovieObject {
        let movieObject = MovieObject()
        movieObject.id = movie.id ?? 0
        movieObject.backdrop_path = movie.backdrop_path
        movieObject.overview = movie.overview
        movieObject.poster_path = movie.poster_path
        movieObject.release_date = movie.release_date
        movieObject.title = movie.title
        movieObject.vote_average = movie.vote_average ?? 0.0
        movieObject.genre_ids = movie.genre_ids
        return movieObject
    }
    
    private func convert_Object_To_Movie(_ object: MovieObject) -> Movie {
        let json: [String: Any] = ["backdrop_path": object.backdrop_path as Any,
                                   "id": object.id,
                                   "overview": object.overview as Any,
                                   "poster_path": object.poster_path as Any,
                                   "release_date": object.release_date as Any,
                                   "title": object.title as Any,
                                   "vote_average": object.vote_average,
                                   "genre_ids": object.genre_ids
        ]
        return Movie(JSON: json)!
    }
}
