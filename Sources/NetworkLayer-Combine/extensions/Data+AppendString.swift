//
//  Data+AppendString.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 2/23/21.
//

import Foundation

extension Data {

    mutating func appendString(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        append(data)
    }
}
