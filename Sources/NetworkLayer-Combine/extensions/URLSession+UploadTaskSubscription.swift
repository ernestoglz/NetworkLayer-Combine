//
//  URLSession+UploadTaskSubscription.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 2/22/21.
//

import Foundation
import Combine

extension URLSession {

    final class UploadTaskSubcription<SubscriberType: Subscriber>: Subscription where
        SubscriberType.Input == (data: Data, response: URLResponse),
        SubscriberType.Failure == Error
    {
        private let subscriber: SubscriberType?
        private weak var session: URLSession?
        private var request: URLRequest
        private var task: URLSessionUploadTask!
        private let body: [MultipartBody]

        init(subscriber: SubscriberType, session: URLSession, request: URLRequest, body: [MultipartBody]) {
            self.subscriber = subscriber
            self.session = session
            self.request = request
            self.body = body
        }

        func request(_ demand: Subscribers.Demand) {
            guard demand > 0, let session = session else { return }

            let builder = MultipartBodyBuilder(multipartBody: body)
            let data = builder.build(with: &request)
            
            task = session.uploadTask(with: request, from: data) { [weak self] data, response, error in
                defer { self?.cancel() }

                guard let response = response else {
                    self?.subscriber?.receive(completion: .failure(error!))
                    return
                }

                guard let data = data else {
                    self?.subscriber?.receive(completion: .failure(error!))
                    return
                }

                _ = self?.subscriber?.receive((data: data, response: response))
                self?.subscriber?.receive(completion: .finished)
            }

            task.resume()
        }

        func cancel() {
            task.cancel()
        }
    }
}
