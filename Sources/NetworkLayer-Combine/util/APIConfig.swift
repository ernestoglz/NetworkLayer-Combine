//
//  APIConfig.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 2/8/21.
//

import Foundation

class ApiConfig {

    static var baseURL: String?
    static var token: String?

    @discardableResult
    init(baseURL: String, token: String) {
        ApiConfig.baseURL = baseURL
        ApiConfig.token = token
    }
}
