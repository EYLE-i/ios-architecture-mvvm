//
//  APIClient.swift
//  ios-architecture-mvc
//
//  Created by AIR on 2023/04/20.
//

import Foundation

protocol APIClient {
    func request<T: APIRequest>(_ requestable: T, completion: @escaping(Result<T.ResponseType, APIError>) -> Void)
}

final class DefaultAPIClient: APIClient {
    static let shared = DefaultAPIClient()
    
    private init() {}
    
    func request<T: APIRequest>(_ requestable: T, completion: @escaping(Result<T.ResponseType, APIError>) -> Void) {
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


final class MockAPIClient: APIClient {
    var mockResult: Result<Decodable, APIError>?
    
    func request<T: APIRequest>(_ requestable: T, completion: @escaping (Result<T.ResponseType, APIError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            guard let dummyResult = self.mockResult else {
                completion(.failure(.unknown(NSError())))
                return
            }
            switch dummyResult {
            case .success(let success):
                completion(.success(success as! T.ResponseType))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
