//
//  RequestError.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 2/8/21.
//

import Foundation

enum RequestError: Error {
    case invalidURL(url: URLConvertible)
}

extension RequestError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case let .invalidURL(url):
            return "URL is not valid: \(url)"
        }
    }
}
