//
//  APIError.swift
//  ios-architecture-mvp
//
//  Created by AIR on 2023/07/09.
//

import Foundation

enum APIError: Error {
    case server(Int)
    case decode(Error)
    case noResponse
    case unknown(Error)
    
    var title: String {
        switch self {
        case .server:
            return "サーバーエラー"
        case .decode:
            return "デコードエラー"
        case .noResponse:
            return "レスポンスエラー"
        case .unknown:
            return "不明なエラー"
        }
    }
    
    var description: String {
        switch self {
        case .server(let code):
            return "サーバーエラーです。(\(code))"
        case .decode:
            return "デコードエラーです。"
        case .noResponse:
            return "レスポンスエラーです。"
        case .unknown:
            return "不明なエラーです。"
        }
    }
}
