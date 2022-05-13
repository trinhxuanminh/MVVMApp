//
//  MovieObject.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 12/05/2022.
//

import Foundation
import RealmSwift

class MovieObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var backdrop_path: String?
    var genre_ids: [Int] = []
    @objc dynamic var overview: String?
    @objc dynamic var poster_path: String?
    @objc dynamic var release_date: String?
    @objc dynamic var title: String?
    @objc dynamic var vote_average: Double = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
