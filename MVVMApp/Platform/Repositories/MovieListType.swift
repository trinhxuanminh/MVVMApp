//
//  MovieList.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 19/04/2022.
//

import ObjectMapper
import Alamofire

enum MovieListInput {
    case getNowPlaying(page: Int)
    case getPopular(page: Int)
}
extension MovieListInput: APIInputBase {
    var headers: HTTPHeaders {
        return HTTPHeaders([
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json"
            ])
    }
    
    var urlString: String {
        switch self {
        case .getNowPlaying:
            return URLs.tmdb + "/movie/now_playing"
        case .getPopular:
            return URLs.tmdb + "/movie/popular"
        }
    }
    
    var requestType: HTTPMethod {
        return .get
    }
    
    var encoding: ParameterEncoding {
        return self.requestType == .get ? URLEncoding.default : JSONEncoding.default
    }
    
    var parameters: [String : Any]? {
        var parameters: [String: Any] = ["api_key": AppText.tmdbKey]
        switch self {
        case .getNowPlaying(let page):
            parameters["page"] = page
        case .getPopular(let page):
            parameters["page"] = page
        }
        return parameters
    }
    
    var requireAccessToken: Bool {
        return true
    }
}

class MovieListOutput: APIOutputBase {
    
    var page: Int?
    var total_pages: Int?
    var movies = [Movie]()
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        self.page <- map["page"]
        self.total_pages <- map["total_pages"]
        self.movies <- map["results"]
    }
}
