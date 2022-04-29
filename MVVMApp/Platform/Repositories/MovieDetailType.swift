//
//  MovieDetail.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import ObjectMapper
import Alamofire

enum MovieDetailInput {
    case getDetail(id: Int, page: Int)
}
extension MovieDetailInput: APIInputBase {
    var headers: HTTPHeaders {
        return HTTPHeaders([
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json"
            ])
    }
    
    var urlString: String {
        switch self {
        case .getDetail(let id, _):
            return URLs.tmdb + "/movie/\(id)"
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
        case .getDetail(_, let page):
            parameters["page"] = page
        }
        return parameters
    }
    
    var requireAccessToken: Bool {
        return true
    }
}

class MovieDetailOutput: APIOutputBase {
    
    var movieDetail: MovieDetail!
    
    init(_ movieDetail: MovieDetail) {
        super.init()
        self.movieDetail = movieDetail
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
    }
}
