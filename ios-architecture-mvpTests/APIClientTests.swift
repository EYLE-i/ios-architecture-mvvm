//
//  APIClientTests.swift
//  ios-architecture-mvpTests
//
//  Created by AIR on 2023/07/13.
//

import XCTest
@testable import ios_architecture_mvp

final class APIClientTests: XCTestCase {
    
    struct MockRequest: APIRequest {
        typealias ResponseType = MockResponse
        var url: String = ""
        var path: String = ""
        var httpMethod: String = ""
        var headers: [String : String] = [:]
        var body: Data? = nil
        var queries: [String : String] = [:]
        var timeout: TimeInterval = 0
    }
    
    struct MockResponse: Decodable, Equatable {
        var name: String = "name"
    }
    
    func test_requestSuccess() {
        let request = MockRequest()
        let response = MockResponse()
        let expectedResult: Result<Decodable, APIError> = .success(response)
        let api = MockAPIClient()
        api.mockResult = expectedResult
        
        let expectation = XCTestExpectation(description: "")
        
        api.request(request) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, response)
                XCTAssertEqual(data.name, "name")
                expectation.fulfill()
            case.failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_requestFailure() {
        let request = MockRequest()
        let error: APIError = .noResponse
        let expectedResult: Result<Decodable, APIError> = .failure(error)
        let api = MockAPIClient()
        api.mockResult = expectedResult
        
        let expectation = XCTestExpectation(description: "")
        
        api.request(request) { result in
            switch result {
            case .success(_):
                XCTFail("request should have failed")
            case .failure(let e):
                XCTAssertEqual(e, error)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
}

extension APIError: Equatable {
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case let (.server(code1), .server(code2)):
            return code1 == code2
        case (.decode, .decode):
            return true
        case (.noResponse, .noResponse):
            return true
        case (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}
