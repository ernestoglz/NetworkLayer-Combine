//
//  DownloadTaskSubscriber.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 2/22/21.
//

import UIKit
import Combine

final class DownloadTaskSubscriber: Subscriber {

    typealias Input = (url: URL, response: URLResponse)
    typealias Failure = URLError

    var subscription: Subscription?

    func receive(subscription: Subscription) {
        self.subscription = subscription
        self.subscription?.request(.unlimited)
    }

    func receive(_ input: Input) -> Subscribers.Demand {
        print("Subscriber value \(input.url)")
        return .unlimited
    }

    func receive(completion: Subscribers.Completion<URLError>) {
        print("Subscriber completion \(completion)")
        subscription?.cancel()
        subscription = nil
    }
}
