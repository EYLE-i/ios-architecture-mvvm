//
//  APIClientTests.swift
//  ios-architecture-mvcTests
//
//  Created by AIR on 2023/07/13.
//

import XCTest
@testable import ios_architecture_mvc

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
    
    func testRequestSuccess() {
        let request = MockRequest()
        let responseData = MockResponse()
        let expectedResult: Result<Any, APIError> = .success(responseData)
        let api = DummyAPIClient(result: expectedResult)
//        let expectation = expectation(description: "")
        
        api.request(request) { result in
            switch result {
            case .success(let model):
                XCTAssertEqual(model, responseData)
                XCTAssertEqual(model.name, "name")
            case.failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
//            expectation.fulfill()
        }
//        wait(for: [expectation], timeout: 10.0)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
