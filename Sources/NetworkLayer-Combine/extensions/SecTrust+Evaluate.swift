//
//  SecTrust+Evaluate.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 2/26/21.
//

import Foundation

extension SecTrust {

    func evaluate() -> Bool {
        var error: CFError?
        let evaluation = SecTrustEvaluateWithError(self, &error)
        return evaluation
    }

    func evaluateAllowing(rootCertificates: [SecCertificate]) -> Bool {
        var err = SecTrustSetAnchorCertificates(self, rootCertificates as CFArray)
        guard err == errSecSuccess else { return false }

        err = SecTrustSetAnchorCertificatesOnly(self, false)
        guard err == errSecSuccess else { return false }

        return self.evaluate()
    }
}
