//
//  NetworkClient.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 2/25/21.
//

import UIKit

class NetworkClient: PerformRequestProtocol {

    let session: URLSession

    init(certificate: SecCertificate? = nil) {
        self.session = URLSession(configuration: .ephemeral, delegate: SessionDelegate(certificate: certificate), delegateQueue: nil)
    }
}
