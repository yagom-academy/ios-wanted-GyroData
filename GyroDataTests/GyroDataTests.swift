//
//  GyroDataTests.swift
//  GyroDataTests
//
//  Created by dhoney96 on 2022/12/27.
//

import XCTest
@testable import GyroData

final class GyroDataTests: XCTestCase {
    var sut: GyroStore!
    var sut2: CoreDataStack!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let inMemoryCoreDataStack = CoreDataStack(inMemory: true)
        sut = GyroStore(dataStack: inMemoryCoreDataStack)
    }

    override func tearDownWithError() throws {
        sut = nil
        sut2 = nil
        try super.tearDownWithError()
    }
    
    func testSaveAndFetch() {
        // given
        let dictionary: [String: Any] = [
            "sensorType": SensorType.gyro.rawValue,
            "measurementTime": Date(timeIntervalSinceNow: 100),
            "measurementDate": "2022.12.27"
        ]
        
        // when
        try! sut.create(by: dictionary)
        let data = try! sut.read()
        
        // then
        XCTAssertEqual(dictionary["sensorType"] as? String, data.first?.sensorType)
    }
    
    func testDeleteAndFetch() {
        // given
        let dictionary: [String: Any] = [
            "sensorType": SensorType.gyro.rawValue,
            "measurementTime": Date(timeIntervalSinceNow: 100),
            "measurementDate": "2022.12.27"
        ]
        
        // when
        try! sut.create(by: dictionary)
        try! sut.delete(measurementDate: (dictionary["measurementDate"] as? String)!)
        let data = try! sut.read()
        
        // then
        XCTAssertTrue(data.isEmpty)
    }
}
