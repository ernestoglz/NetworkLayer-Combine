//
//  Publishers+DecodeRequest.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 2/24/21.
//

import Foundation
import Combine

extension Publisher  {

    typealias ResponseOutput = (data: Data, response: URLResponse)

    func genericError() -> AnyPublisher<Self.Output, Error> {
        return self
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    func decodeRequest<Item>(type: Item.Type) -> AnyPublisher<Item, Self.Failure> where Item: Decodable, Output == ResponseOutput, Failure == Error {
        return
            tryMap { result in
                let decoder = JSONDecoder()

                debugPrint(result)

                guard let urlResponse = result.response as? HTTPURLResponse, (200...305).contains(urlResponse.statusCode) else {
                    let apiError = try decoder.decode(ErrorRequest.self, from: result.data)
                    throw apiError
                }

                return try decoder.decode(type, from: result.data)
            }
            .mapError { error -> Error in
                switch error {
                case let error as ErrorRequest:
                    return error
                case let error as DecodingError:
                    return ErrorRequest(statusCode: 0, errorCode: "Decoding error code", message: error.localizedDescription)
                default:
                    return ErrorRequest(statusCode: 0, errorCode: "Unknown API error Code", message: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
}
