//
//  RouterConfigProtocol.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 2/8/21.
//

import Foundation

typealias Parameters = [String: Any]

protocol RouterConfigProtocol {
    var headers: [String: String]? { get }
    var httpMethod: HTTPMethod { get }
    var requestPath: String { get }
    var queryItems: [URLQueryItem]? { get }
    var multipartFormData: [MultipartBody]? { get }
    var parameters: Parameters? { get }
}
