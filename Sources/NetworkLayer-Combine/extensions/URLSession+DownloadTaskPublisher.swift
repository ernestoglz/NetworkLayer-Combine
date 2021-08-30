//
//  URLSession+DownloadTaskPublisher.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 2/12/21.
//

import Foundation
import Combine

extension URLSession {

    func downloadTaskPublisher(for url: URL) -> URLSession.DownloadTaskPublisher {
        downloadTaskPublisher(for: .init(url: url))
    }

    func downloadTaskPublisher(for request: URLRequest) -> URLSession.DownloadTaskPublisher {
        .init(request: request, session: self)
    }

    struct DownloadTaskPublisher: Publisher {

        typealias Output = (url: URL, response: URLResponse)
        typealias Failure = URLError

        let request: URLRequest
        let session: URLSession

        func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = DownloadTaskSubscription(subscriber: subscriber, session: session, request: request)
            subscriber.receive(subscription: subscription)
        }
    }
}
