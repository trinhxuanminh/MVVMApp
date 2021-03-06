//
//  MovieDetail.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import ObjectMapper

struct MovieDetail: BaseModel {
    var backdrop_path: String?
    var genre_ids: [Int] = []
    var id: Int?
    var overview: String?
    var poster_path: String?
    var release_date: String?
    var title: String?
    var vote_average: Double?
    var runtime: Int?
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.backdrop_path <- map["backdrop_path"]
        self.genre_ids <- map["genre_ids"]
        self.id <- map["id"]
        self.overview <- map["overview"]
        self.poster_path <- map["poster_path"]
        self.release_date <- map["release_date"]
        self.title <- map["title"]
        self.vote_average <- map["vote_average"]
        self.runtime <- map["runtime"]
    }
}
