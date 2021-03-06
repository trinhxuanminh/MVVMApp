//
//  APIService.swift
//  MGMVVMRxSwiftDemo
//
//  Created by Tuan Truong on 6/4/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import RxSwift
import ObjectMapper
import RxCocoa
import Alamofire
import RxAlamofire

enum APIError: Error {
    case invalidURL(url: String)
    case invalidResponseData(data: Any)
    case error(responseCode: Int, data: Any)
}

protocol APIServiceProtocol {
    func request<T: Mappable>(_ input: APIInputBase) -> Observable<T>
    func requestArray<T: Mappable>(_ input: APIInputBase) -> Observable<[T]>
}

class APIService: APIServiceProtocol {
    
    private func _request(_ input: APIInputBase) -> Observable<Any> {
        let manager = Alamofire.Session.default
        
        return manager.rx
            .request(input.requestType,
                     input.urlString,
                     parameters: input.parameters,
                     encoding: input.encoding,
                     headers: input.headers)
            .flatMap { dataRequest -> Observable<DataResponse<Any, AFError>> in
                return dataRequest.rx.responseJSON()
            }
            .map { response -> Any in
                return try self.process(response)
            }
    }
    
    private func process(_ response: DataResponse<Any, AFError>) throws -> Any {
        let error: Error
        switch response.result {
        case .success(let value):
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 200:
                    return value
                case 304:
                    error = ResponseError.notModified
                case 400:
                    error = ResponseError.invalidRequest
                case 401:
                    error = ResponseError.unauthorized
                case 403:
                    error = ResponseError.accessDenied
                case 404:
                    error = ResponseError.notFound
                case 405:
                    error = ResponseError.methodNotAllowed
                case 422:
                    error = ResponseError.validate
                case 500:
                    error = ResponseError.serverError
                case 502:
                    error = ResponseError.badGateway
                case 503:
                    error = ResponseError.serviceUnavailable
                case 504:
                    error = ResponseError.gatewayTimeout
                default:
                    error = ResponseError.unknown(statusCode: statusCode)
                }
            }
            else {
                error = ResponseError.noStatusCode
            }
        case .failure(let e):
            error = e
        }
        print(error)
        throw error
    }
    
    func request<T: Mappable>(_ input: APIInputBase) -> Observable<T> {
        return _request(input)
            .map { data -> T in
                if let json = data as? [String: Any], let item = T(JSON: json) {
                    return item
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
            }

    }
    
    func requestArray<T: Mappable>(_ input: APIInputBase) -> Observable<[T]> {
        return _request(input)
            .map { data -> [T] in
                if let jsonArray = data as? [[String: Any]] {
                    return Mapper<T>().mapArray(JSONArray: jsonArray)
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
        }
    }
    
    static func imageURL(path: String) -> URL? {
        let urlString: String = URLs.baseImage + path
        return URL(string: urlString)
    }
}

