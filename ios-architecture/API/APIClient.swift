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

protocol Requestable {
    associatedtype Model
    var url: String { get }
    var httpMethod: String { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    func decode(from data: Data) throws -> Model
}

extension Requestable {
    var urlRequest: URLRequest? {
        guard let url = URL(string: url) else { return nil }
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
}

protocol APIClient {
    func request<T: Requestable>(_ requestable: T, completion: @escaping(Result<T.Model?, APIError>) -> Void)
}

class DefaultAPIClient: APIClient {
    func request<T: Requestable>(_ requestable: T, completion: @escaping(Result<T.Model?, APIError>) -> Void) {
        guard let request = requestable.urlRequest else { return }
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 60
        let session: URLSession = URLSession(configuration: config)
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

struct PokeListAPIRequest: Requestable {
    typealias Model = PokemonListResponse
    
    var url: String {
        return "https://pokeapi.co/api/v2/pokemon/?limit=1281"
    }
    
    var httpMethod: String {
        return "GET"
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var body: Data? {
        return nil
    }
    
    func decode(from data: Data) throws -> PokemonListResponse {
        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(PokemonListResponse.self, from: data)
    }
    
}
