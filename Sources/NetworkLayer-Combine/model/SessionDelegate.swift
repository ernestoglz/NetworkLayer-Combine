//
//  SessionDelegate.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 2/26/21.
//

import UIKit

class SessionDelegate: NSObject {

    let certificate: SecCertificate?

    init(certificate: SecCertificate? = nil) {
        self.certificate = certificate
    }
}

extension SessionDelegate: URLSessionDelegate {

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        guard let certificate = certificate, let trust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        if trust.evaluateAllowing(rootCertificates: [certificate]) {
            completionHandler(.useCredential, URLCredential(trust: trust))
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
