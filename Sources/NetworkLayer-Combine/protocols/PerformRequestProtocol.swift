//
//  PerformRequestProtocol.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 2/8/21.
//

import Foundation
import Combine

protocol PerformRequestProtocol {
    var session: URLSession { get }

    // The idea to have these functions also in the protocol is to be able to create a mock network client for the unit testing
    // So we can rewrite the function's body into the mock client
    func performRequest<T>(config: ApiConfigProtocol, router: RouterConfigProtocol, type: T.Type) -> AnyPublisher<T, Error> where T: Decodable
    func performDownloadFileRequest(url: URL) -> AnyPublisher<URL, Error>
    func performUploadRequest<T>(config: ApiConfigProtocol, router: RouterConfigProtocol, type: T.Type) -> AnyPublisher<T, Error> where T: Decodable
}

extension PerformRequestProtocol {

    /// Perform a basic request (GET, POST, PUT, DELETE)
    /// - Parameters:
    ///   - config: APIConfigurationProtocol which containts a URLRequest object configured for the request
    ///   - type: Model object type to be decoded
    /// - Returns: A publisher that could returns the data model decoded requested or an error
    func performRequest<T>(config: ApiConfigProtocol, router: RouterConfigProtocol, type: T.Type) -> AnyPublisher<T, Error> where T: Decodable {
        guard let urlRequest = try? config.asURLRequest(router: router) else { fatalError("Invalid URL") }

        return session.dataTaskPublisher(for: urlRequest)
            .genericError()
            .decodeRequest(type: type)
            .eraseToAnyPublisher()
    }

    /// Downloads a file from a given URL.
    /// - Parameter url: `URL` when the asset to download lives.
    /// - Returns: A publisher that could returns the URL of the local path where the asset lives or an error.
    func performDownloadFileRequest(url: URL) -> AnyPublisher<URL, Error> {
        return session.downloadTaskPublisher(for: url)
            .tryMap { result in
                guard let urlResponse = result.response as? HTTPURLResponse, (200...305).contains(urlResponse.statusCode) else {
                    throw ErrorRequest(errorCode: "605", message: "Error downloading file")
                }

                return result.url
            }
            .mapError { error in
                switch error {
                case let error as ErrorRequest:
                    return error
                default:
                    return ErrorRequest(statusCode: 0, errorCode: "Unknown API error Code", message: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }

    /// Uploads a file into the server.
    /// - Parameters:
    ///   - config: `ApiConfigProtocol` that creates an `URLRequest` object
    ///   - router: `RouterConfigProtocol` with specific endpoint's properties.
    ///   - type: Model object type to be decoded.
    /// - Returns: A publisher that could returns the data model decoded requested or an error
    func performUploadRequest<T>(config: ApiConfigProtocol, router: RouterConfigProtocol, type: T.Type) -> AnyPublisher<T, Error> where T: Decodable {
        guard let urlRequest = try? config.asURLRequest(router: router) else { fatalError("Invalid URL") }

        guard let requestBody = router.multipartFormData else {
            return AnyPublisher(Fail<T, Error>(error: ErrorRequest(statusCode: 0, errorCode: "Multipart code error", message: "No multipart body")))
        }

        return session.uploadTaskPublisher(for: urlRequest, body: requestBody)
            .genericError()
            .decodeRequest(type: type)
            .eraseToAnyPublisher()
    }
}

