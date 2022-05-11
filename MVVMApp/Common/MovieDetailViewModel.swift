//
//  MovieDetailViewModel.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import RxSwift
import RxCocoa
import Differentiator
import Action
import SDWebImage

protocol MovieDetailViewModelProtocol {
    var backAction: Action<Void, Void>! { get }
    
    var backdrop: BehaviorSubject<UIImage?> { get }
    var poster: BehaviorSubject<UIImage?> { get }
    var name: BehaviorSubject<String?> { get }
    var date: BehaviorSubject<String?> { get }
    var runtime: BehaviorSubject<String?> { get }
}

class MovieDetailViewModel: MovieDetailViewModelProtocol {
    
    private let disposeBag: DisposeBag
    private let useCase: MovieDetailUseCaseProtocol
    private let navigator: MovieDetailNavigatorProtocol
    
    // MARK: - Input
    private(set) var backAction: Action<Void, Void>!
    // MARK: - Output
    private(set) var backdrop = BehaviorSubject<UIImage?>(value: AppIcon.image(icon: .defaultIcon2))
    private(set) var poster = BehaviorSubject<UIImage?>(value: AppIcon.image(icon: .defaultIcon))
    private(set) var name = BehaviorSubject<String?>(value: AppText.ItemDefault.unknown.rawValue)
    private(set) var date = BehaviorSubject<String?>(value: AppText.ItemDefault.date.rawValue)
    private(set) var runtime = BehaviorSubject<String?>(value: AppText.ItemDefault.number.rawValue)
    
    private(set) var movieDetail = BehaviorSubject<MovieDetail?>(value: nil)
    
    init(movie: Movie, disposeBag: DisposeBag, useCase: MovieDetailUseCaseProtocol, navigator: MovieDetailNavigatorProtocol) {
        self.disposeBag = disposeBag
        self.useCase = useCase
        self.navigator = navigator
        self.binding()
        self.loadMovieDetail(movie: movie)
    }
    
    private func binding() {
        self.backAction = Action { [weak self] _ in
            guard let self = self else {
                return Observable.never()
            }
            self.navigator.back()
            return Observable.empty()
        }
        
        self.movieDetail.subscribe(onNext: { [weak self] movieDetail in
            guard let self = self, let movieDetail = movieDetail else {
                return
            }
            self.bindBackdrop(backdrop_path: movieDetail.backdrop_path)
            self.bindPoster(poster_path: movieDetail.poster_path)
            self.bindName(title: movieDetail.title)
            self.bindDate(release_date: movieDetail.release_date)
            self.bindRuntime(runtime: movieDetail.runtime)
        }).disposed(by: self.disposeBag)
    }
    
    private func loadMovieDetail(movie: Movie) {
        self.useCase.loadMovieDetail(movie).subscribe(onNext: { movieDetail in
            self.movieDetail.onNext(movieDetail)
        }).disposed(by: self.disposeBag)
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
    
    private func bindBackdrop(backdrop_path: String?) {
        if let backdrop_path = backdrop_path, let url = APIService.imageURL(path: backdrop_path) {
            SDWebImageManager.shared.loadImage(with: url, progress: nil, completed: { image, _, error, _, _, _ in
                if let image = image {
                    self.backdrop.onNext(image)
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
    
    private func bindRuntime(runtime: Int?) {
        if let runtime = runtime {
            self.runtime.onNext("Runtime: " + String(runtime) + " m")
        }
    }
}
