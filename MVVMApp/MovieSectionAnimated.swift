//
//  MovieSectionAnimated.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 11/05/2022.
//

import Foundation
import RxCocoa
import RxDataSources

struct MovieAnimated {
    let movie: Movie?
    
    init(movie: Movie) {
        self.movie = movie
    }
}

extension MovieAnimated: IdentifiableType, Equatable {
    typealias Identity = Int

    var identity: Identity {
        return movie?.id ?? 0
    }
}

struct MovieSectionAnimated {
    var items: [Item]

    // Need to provide a unique id, only one section in our model
    var identity: Int {
        return 0
    }
}

extension MovieSectionAnimated: AnimatableSectionModelType {
    typealias Identity = Int
    typealias Item = MovieAnimated

    init(original: MovieSectionAnimated, items: [MovieAnimated]) {
        self = original
        self.items = items
    }
}
