//
//  Api.swift
//  NetworkLayer-Combine
//
//  Created by Ernesto Gonzalez on 23/8/21.
//

import Foundation

enum Api: ApiConfigProtocol {

    case udr(token: String = "")
    case local

    var baseURL: String {
        switch self {
        case .udr: return "https://stage-api.udr.com/v1/res-pt"
        case .local: return "local"
        }
    }

    var headers: [String: String]? {
        switch self {
        case .udr(let token): return ["Authorization": "Bearer \(token)"]
        case .local: return nil
        }
    }
}
