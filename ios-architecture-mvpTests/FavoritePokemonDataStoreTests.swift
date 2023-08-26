//
//  FavoritePokemonDataStoreTests.swift
//  ios-architecture-mvpTests
//
//  Created by AIR on 2023/08/10.
//

import XCTest
@testable import ios_architecture_mvp

final class FavoritePokemonDataStoreTests: XCTestCase {
    
    var dataStore: FavoritePokemonDataStore!
    var userDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        
        userDefaults = UserDefaults(suiteName: "testUserDefaults")
        dataStore = FavoritePokemonDataStoreImpl(userDefaults: userDefaults)
    }
    
    override func tearDown() {
        dataStore = nil
        userDefaults.removePersistentDomain(forName: "testUserDefaults")
        userDefaults = nil
        
        super.tearDown()
    }
    
    func testFetchAll() {
        let favoriteNumbers: [Int] = [1, 3, 5]
        userDefaults.set(favoriteNumbers, forKey: FavoritePokemonDataStoreImpl.Key.favoriteNumbers.rawValue)
        
        let fetchedNumbers = dataStore.fetchAll()
        XCTAssertEqual(fetchedNumbers, favoriteNumbers)
    }
    
    func testAdd() {
        let favoriteNumbers: [Int] = [1, 3, 5]
        userDefaults.set(favoriteNumbers, forKey: FavoritePokemonDataStoreImpl.Key.favoriteNumbers.rawValue)
        
        let newNumberToAdd: Int = 7
        let expectedResult: [Int] = favoriteNumbers + [newNumberToAdd]
        
        let result = dataStore.add([newNumberToAdd])
        switch result {
        case .success(let updatedNumbers):
            XCTAssertEqual(updatedNumbers, expectedResult)
            XCTAssertEqual(userDefaults.array(forKey: FavoritePokemonDataStoreImpl.Key.favoriteNumbers.rawValue) as? [Int], expectedResult)
        case .failure(let error):
            XCTFail("Add operation should succeed, but failed with error: \(error)")
        }
    }
    
    func testRemove() {
        let favoriteNumbers: [Int] = [1, 3, 5]
        userDefaults.set(favoriteNumbers, forKey: FavoritePokemonDataStoreImpl.Key.favoriteNumbers.rawValue)
        
        let numbersToRemove: [Int] = [3, 5]
        let expectedResult: [Int] = [1]
        
        let result = dataStore.remove(numbersToRemove)
        switch result {
        case .success(let updatedNumbers):
            XCTAssertEqual(updatedNumbers, expectedResult)
            XCTAssertEqual(userDefaults.array(forKey: FavoritePokemonDataStoreImpl.Key.favoriteNumbers.rawValue) as? [Int], expectedResult)
        case .failure(let error):
            XCTFail("Remove operation should succeed, but failed with error: \(error)")
        }
    }
}
