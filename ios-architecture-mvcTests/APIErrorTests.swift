//
//  APIErrorTests.swift
//  ios-architecture-mvcTests
//
//  Created by AIR on 2023/07/10.
//

import XCTest
@testable import ios_architecture_mvc

final class APIErrorTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testErrorTitle() {
        XCTAssertEqual(APIError.server(404).title, "サーバーエラー")
        XCTAssertEqual(APIError.decode(NSError()).title, "デコードエラー")
        XCTAssertEqual(APIError.noResponse.title, "レスポンスエラー")
        XCTAssertEqual(APIError.unknown(NSError()).title, "不明なエラー")
    }
    
    func testErrorDescription() {
        XCTAssertEqual(APIError.server(404).description, "サーバーエラーです。(404)")
        XCTAssertEqual(APIError.decode(NSError()).description, "デコードエラーです。")
        XCTAssertEqual(APIError.noResponse.description, "レスポンスエラーです。")
        XCTAssertEqual(APIError.unknown(NSError()).description, "不明なエラーです。")
    }
}
