//
//  Certificates.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 2/25/21.
//

import Foundation

struct Certificates {

    /// Retrives the SSL certificate saved in te bundle
    /// - Parameter filename: Certificate name
    /// - Returns: SecCertificate object
    static func certificate(filename: String) -> SecCertificate {
        guard
            let filePath = Bundle.main.path(forResource: filename, ofType: "der"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: filePath))
            else { fatalError("File must to exist") }

        guard let certificate = SecCertificateCreateWithData(nil, data as CFData) else {
            fatalError("Couldn't create certificate with data")
        }

        return certificate
    }
}
