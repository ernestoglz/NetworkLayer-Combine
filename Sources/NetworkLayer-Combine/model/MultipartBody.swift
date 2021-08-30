//
//  MultipartBody.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 2/23/21.
//

import Foundation

struct MultipartBody: Codable {

    let name: String
    let value: Data
    let fileName: String?
    let mimeType: String?

    init(name: String, value: Data, fileName: String? = nil, mimeType: String? = nil) {
        self.name = name
        self.value = value
        self.fileName = fileName
        self.mimeType = mimeType
    }
}
