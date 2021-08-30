//
//  MultipartBodyBuilder.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 2/23/21.
//

import Foundation

class MultipartBodyBuilder {

    private let boundary = "Boundary-\(UUID().uuidString)"
    private let encodingCRLFChars = "\r\n"
    private let multipartBody: [MultipartBody]

    init(multipartBody: [MultipartBody]) {
        self.multipartBody = multipartBody
    }

    private func append(_ file: Data, withName name: String, fileName: String?, mimeType: String?) -> Data {
        var headerData = Data()

        headerData.appendString("--\(boundary)\r\n")

        guard let mimeType = mimeType, let fileName = fileName else {
            headerData.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n")
            headerData.appendString("\r\n")
            headerData.append(file)
            headerData.appendString("\r\n")
            return headerData
        }

        headerData.appendString("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n")
        headerData.appendString("Content-Type: \(mimeType)\r\n\r\n")
        headerData.append(file)
        headerData.appendString("\r\n")

        return headerData
    }

    func build(with request: inout URLRequest) -> Data {
        var httpBody = Data()

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        multipartBody.forEach { bodyField in
            httpBody.append(append(bodyField.value, withName: bodyField.name, fileName: bodyField.fileName, mimeType: bodyField.mimeType))
        }

        httpBody.appendString("--\(boundary)--")
        return httpBody
    }
}
