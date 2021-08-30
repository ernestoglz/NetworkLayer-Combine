//
//  ApiConfigProtocol.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto González on 3/15/21.
//

import Foundation

protocol ApiConfigProtocol {
    var baseURL: String { get }
    var headers: [String: String]? { get }
}

extension ApiConfigProtocol {

    /// Creates the path if is necessary to consume a file from the bound
    /// - Parameter path: Request path.
    /// - Returns: Formatted request path.
    private func currentRequestPath(path: String) -> String {
        if baseURL.contains("file") {
            let filePath = path.replacingOccurrences(of: "/", with: "_")
            return "\(filePath).json"
        }

        return path
    }

    /// Create an `URLRequest` with the data necessary for the request.
    /// - Parameter router: `RouterConfigProtocol` that contains endpoint's information.
    /// - Throws: Exception in case the parameters can not be serialized
    /// - Returns: `URLRequest` with the data necessary for the request.
    func asURLRequest(router: RouterConfigProtocol) throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest: URLRequest!

        if let queryItems = router.queryItems, var urlComponents = URLComponents(string: url.absoluteString) {
            urlComponents.path = urlComponents.path + currentRequestPath(path: router.requestPath)
            urlComponents.queryItems = queryItems
            urlRequest = URLRequest(url: try urlComponents.asURL())
        } else {
            urlRequest = URLRequest(url: url.appendingPathComponent(currentRequestPath(path: router.requestPath)))
        }

        urlRequest.httpMethod = router.httpMethod.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestHeaders = headers?.merging(router.headers ?? [:]) { (_, second) in second }

        if let headers = requestHeaders {
            headers.forEach { key, value in
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }

        if let parameters = router.parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw error
            }
        }

        return urlRequest
    }
}
