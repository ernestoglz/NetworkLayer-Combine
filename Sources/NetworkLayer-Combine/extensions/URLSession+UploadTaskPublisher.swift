//
//  URLSession+UploadTaskPublisher.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 2/22/21.
//

import Foundation
import Combine

extension URLSession {

    func uploadTaskPublisher(for request: URLRequest, body: [MultipartBody]) -> URLSession.UploadTaskPublisher {
        .init(request: request, session: self, body: body)
    }

    struct UploadTaskPublisher: Publisher {

        typealias Output = (data: Data, response: URLResponse)
        typealias Failure = Error

        let request: URLRequest
        let session: URLSession
        let body: [MultipartBody]

        func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = UploadTaskSubcription(subscriber: subscriber, session: session, request: request, body: body)
            subscriber.receive(subscription: subscription)
        }
    }
}
