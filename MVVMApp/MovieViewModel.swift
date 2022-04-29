//
//  MovieViewModel.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 19/04/2022.
//

import Foundation
import RxSwift
import RxCocoa
import SDWebImage
import Action

class MovieViewModel {
    
    let disposeBag = DisposeBag()
    private let useCase = MovieUseCase()
    private let navigator = MovieNavigator()
    
    // MARK: - Input
    private(set) var deleteFavoriteAction: Action<Void, Void>!
    private(set) var setFavoriteAction: Action<Void, Void>!
    // MARK: - Output
    private(set) var poster = BehaviorSubject<UIImage?>(value: AppIcon.image(icon: .defaultIcon))
    private(set) var name = BehaviorSubject<String?>(value: AppText.ItemDefault.unknown.rawValue)
    private(set) var date = BehaviorSubject<String?>(value: AppText.ItemDefault.date.rawValue)
    private(set) var vote = BehaviorSubject<String?>(value: AppText.ItemDefault.number.rawValue)
    private(set) var favoriteState = BehaviorSubject<UIImage?>(value: nil)
    
    private(set) var movie = BehaviorSubject<Movie?>(value: nil)
    
    init(movie: Movie) {
        self.binding()
        self.movie.onNext(movie)
        self.favoriteState.onNext(AppIcon.image(icon: self.useCase.isFavorite(movie) ? .selectFavorite : .deselectFavorite))
    }
    
    private func binding() {
        self.movie.bind { [weak self] movie in
            guard let self = self, let movie = movie else {
                return
            }
            self.bindPoster(poster_path: movie.poster_path)
            self.bindName(title: movie.title)
            self.bindDate(release_date: movie.release_date)
            self.bindVote(vote_average: movie.vote_average)
        }.disposed(by: self.disposeBag)
        
        self.deleteFavoriteAction = Action { [weak self] _ in
            guard let self = self, let movie = try? self.movie.value() else {
                return Observable.never()
            }
            self.useCase.deleteFavorite(movie)
            self.favoriteState.onNext(AppIcon.image(icon: .deselectFavorite))
            
            return Observable.empty()
        }
        
        self.setFavoriteAction = Action { [weak self] _ in
            guard let self = self, let movie = try? self.movie.value() else {
                return Observable.never()
            }
            let isFavorite = self.useCase.setFavorite(movie)
            self.favoriteState.onNext(AppIcon.image(icon: isFavorite ? .deselectFavorite : .selectFavorite))
            return Observable.empty()
        }
    }
    
    private func bindPoster(poster_path: String?) {
        if let poster_path = poster_path, let url = APIService.imageURL(path: poster_path) {
            SDWebImageManager.shared.loadImage(with: url, progress: nil, completed: { image, _, error, _, _, _ in
                if let image = image {
                    self.poster.onNext(image)
                }
            })
        }
    }
    
    private func bindName(title: String?) {
        if let title = title {
            self.name.onNext(title)
        }
    }
    
    private func bindDate(release_date: String?) {
        if let release_date = release_date, let date = release_date.convertToDate() {
            self.date.onNext(date.asStringDateEnglish())
        }
    }
    
    private func bindVote(vote_average: Double?) {
        if let vote_average = vote_average {
            self.vote.onNext(String(vote_average))
        }
    }
}
