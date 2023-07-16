//
//  APIRequestTests.swift
//  ios-architecture-mvcTests
//
//  Created by AIR on 2023/07/11.
//

import XCTest
@testable import ios_architecture_mvc

struct MockResponse: Decodable {
    let message: String
}

struct MockAPIRequest: APIRequest {
    typealias ResponseType = MockResponse
    
    let url: String = "https://example.com"
    let path: String = "/api"
    let httpMethod: String = "GET"
    let headers: [String: String] = ["Content-Type": "application/json"]
    let body: Data? = nil
    let queries: [String: String] = ["param1": "value1"]
    let timeout: TimeInterval = 30.0
    
    func decode(from data: Data) throws -> ResponseType {
        let decoder = JSONDecoder()
        return try decoder.decode(ResponseType.self, from: data)
    }
}

final class APIRequestTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testURLRequest() {
        let request = MockAPIRequest()
        let urlRequest = request.urlRequest
        
        XCTAssertNotNil(urlRequest)
        XCTAssertEqual(urlRequest?.url?.absoluteString, "https://example.com/api?param1=value1")
        XCTAssertEqual(request.urlRequest?.allHTTPHeaderFields?.count, 1)
        XCTAssertEqual(urlRequest?.httpMethod, "GET")
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertNil(urlRequest?.httpBody)
    }
    
    func testSession() {
        let request = MockAPIRequest()
        let session = request.session
        
        XCTAssertNotNil(session)
        XCTAssertEqual(session.configuration.timeoutIntervalForResource, 30.0)
    }
    
    func testDecode() throws {
        let request = MockAPIRequest()
        let responseString = """
            {
                "message": "Hello, World!"
            }
            """
        let responseData = responseString.data(using: .utf8)!
        
        let decodedResponse = try request.decode(from: responseData)
        XCTAssertEqual(decodedResponse.message, "Hello, World!")
    }
}
