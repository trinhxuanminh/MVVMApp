//
//  APIInput.swift
//  MGMVVMRxSwiftDemo
//
//  Created by Tuan Truong on 6/5/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

protocol APIInputBase {
    var headers: HTTPHeaders { get }
    var urlString: String { get }
    var requestType: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var parameters: [String: Any]? { get }
    var requireAccessToken: Bool { get }
}
