//
//  MultipartBodyBuilder.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 2/23/21.
//

import Foundation

class MultipartBodyBuilder {

    let boundary = UUID().uuidString
    let encodingCRLFChars = "\r\n"
    lazy var contentType: String = "multipart/form-data; boundary=\(boundary)"
    private weak var session: URLSession?

    init(session: URLSession) {
        self.session = session
    }

    func append(_ value: String, withName name: String) -> String {
        var fieldString = "--\(boundary)\(encodingCRLFChars)"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\(encodingCRLFChars)"
        fieldString += "\(encodingCRLFChars)"
        fieldString += "\(value)\(encodingCRLFChars)"

        return fieldString
    }

    func append(_ file: Data, withName name: String, fileName: String, mimeType: String) -> Data {
        let mutableData = NSMutableData()

        mutableData.appendString("--\(boundary)\(encodingCRLFChars)")
        mutableData.appendString("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\(encodingCRLFChars)")
        mutableData.appendString("Content-Type: \(mimeType)\(encodingCRLFChars)\(encodingCRLFChars)")
        mutableData.append(file)
        mutableData.appendString("\(encodingCRLFChars)")

        return mutableData as Data
    }

    func build() -> Data {
        return Data()
    }
}
