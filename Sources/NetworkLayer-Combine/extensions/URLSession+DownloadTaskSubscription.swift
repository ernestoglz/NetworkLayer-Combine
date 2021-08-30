//
//  URLSession+DownloadTaskSubscription.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 2/22/21.
//

import Foundation
import Combine

extension URLSession {

    final class DownloadTaskSubscription<SubscriberType: Subscriber>: Subscription where
        SubscriberType.Input == (url: URL, response: URLResponse),
        SubscriberType.Failure == URLError
    {
        private var subscriber: SubscriberType?
        private weak var session: URLSession?
        private var request: URLRequest
        private var task: URLSessionDownloadTask!

        init(subscriber: SubscriberType, session: URLSession, request: URLRequest) {
            self.subscriber = subscriber
            self.session = session
            self.request = request
        }

        func request(_ demand: Subscribers.Demand) {
            guard demand > 0, let session = session else { return }

            task = session.downloadTask(with: request, completionHandler: { [weak self] url, response, error in
                defer { self?.cancel() }

                guard let response = response else {
                    self?.subscriber?.receive(completion: .failure(URLError(.badServerResponse)))
                    return
                }

                guard let url = url else {
                    self?.subscriber?.receive(completion: .failure(URLError(.badURL)))
                    return
                }

                do {
                    guard let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { fatalError("Invalid directory") }

                    let fileURL = cacheDir.appendingPathComponent(UUID().uuidString)
                    try FileManager.default.moveItem(atPath: url.path, toPath: fileURL.path)
                    _ = self?.subscriber?.receive((url: fileURL, response: response))
                    self?.subscriber?.receive(completion: .finished)
                } catch {
                    self?.subscriber?.receive(completion: .failure(URLError(.cannotCreateFile)))
                }
            })

            task.resume()
        }

        func cancel() {
            task.cancel()
        }
    }
}
