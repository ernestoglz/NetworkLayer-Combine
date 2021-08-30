//
//  URLConvertible+URLConvertibleRequest.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 2/8/21.
//

import Foundation

protocol URLConvertible {
    func asURL() throws -> URL
}

extension String: URLConvertible {

    func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw RequestError.invalidURL(url: self) }
        return url
    }
}

extension URLComponents: URLConvertible {

    func asURL() throws -> URL {
        guard let url = url else { throw RequestError.invalidURL(url: self) }
        return url
    }
}
