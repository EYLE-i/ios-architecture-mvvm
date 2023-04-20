//
//  APIClient.swift
//  ios-architecture
//
//  Created by AIR on 2023/04/20.
//

import Foundation

public enum APIError: Error {
    case server(Int)
    case decode(Error)
    case noResponse
    case unknown(Error)
}

public protocol Requestable {
    associatedtype Model
    var url: String { get }
    var httpMethod: String { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    var queries: [String: String] { get }
    var timeout: TimeInterval { get }
    func decode(from data: Data) throws -> Model
}

public extension Requestable {
    var urlRequest: URLRequest? {
        guard var urlComponents = URLComponents(string: url) else { return nil }
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

public protocol APIClient {
    func request<T: Requestable>(_ requestable: T, completion: @escaping(Result<T.Model, APIError>) -> Void)
}

public final class DefaultAPIClient: APIClient {
    public static let shared = DefaultAPIClient()
    
    private init() {}
    
    public func request<T: Requestable>(_ requestable: T, completion: @escaping(Result<T.Model, APIError>) -> Void) {
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
