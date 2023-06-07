//
//  APIClient.swift
//  ios-architecture-mvc
//
//  Created by AIR on 2023/04/20.
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
        case .server:
            return "サーバーエラーです。"
        case .decode:
            return "デコードエラーです。"
        case .noResponse:
            return "レスポンスエラーです。"
        case .unknown:
            return "不明なエラーです。"
        }
    }
}

protocol Requestable {
    associatedtype Model
    var url: String { get }
    var path: String { get }
    var httpMethod: String { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    var queries: [String: String] { get }
    var timeout: TimeInterval { get }
    func decode(from data: Data) throws -> Model
}

extension Requestable {
    var urlRequest: URLRequest? {
        guard var urlComponents = URLComponents(string: url + path) else { return nil }
        var urlQueryItems: [URLQueryItem] = []
        queries.forEach { key, value in
            urlQueryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = urlQueryItems
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        if let body = body {
            request.httpBody = body
        }
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    var session: URLSession {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForResource = timeout
        let session = URLSession(configuration: config)
        return session
    }
}

protocol APIClient {
    func request<T: Requestable>(_ requestable: T, completion: @escaping(Result<T.Model, APIError>) -> Void)
}

final class DefaultAPIClient: APIClient {
    static let shared = DefaultAPIClient()
    
    private init() {}
    
    func request<T: Requestable>(_ requestable: T, completion: @escaping(Result<T.Model, APIError>) -> Void) {
        guard let request = requestable.urlRequest else { return }
        let session = requestable.session
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if let error = error {
                completion(.failure(APIError.unknown(error)))
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                completion(.failure(APIError.noResponse))
                return
            }
            if case 200..<300 = response.statusCode {
                do {
                    let model = try requestable.decode(from: data)
                    completion(.success(model))
                } catch let decodeError {
                    completion(.failure(APIError.decode(decodeError)))
                }
            } else {
                completion(.failure(APIError.server(response.statusCode)))
            }
        })
        task.resume()
    }
}
