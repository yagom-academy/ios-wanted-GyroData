//
//  MotionCreateServiceTests.swift
//  GyroDataTests
//
//  Created by Ayaan, Wonbi on 2023/02/01.
//

import XCTest
@testable import GyroData

final class MotionCreateServiceTests: XCTestCase {
    var coreDataRepository: CoreDataRepositoryMock!
    var fileManagerRepository: FileManagerRepositoryMock!
    var service: GyroData.MotionCreateService!
    
    let dateDummy = "2023/02/01 20:57:00"
    let typeDummy = 0
    let timeDummy = "60.0"
    let dataDummy: [MotionDataType] = []

    override func setUpWithError() throws {
        coreDataRepository = CoreDataRepositoryMock()
        fileManagerRepository = FileManagerRepositoryMock()
        service = GyroData.MotionCreateService(coreDataRepository: coreDataRepository,
                                               fileManagerRepository: fileManagerRepository)
    }

    override func tearDownWithError() throws {
        coreDataRepository = nil
        fileManagerRepository = nil
        service = nil
    }
    
    func test_create_with_invalid_date_then_completion_argument_and_repository_isCalledCreateFunction_is_false() {
        let expectation = XCTestExpectation(description: "Invalid Date Test")
        let invalidDateDummy = "Wrong Date Dummy"
        service.create(
            date: invalidDateDummy,
            type: typeDummy,
            time: timeDummy,
            data: dataDummy) { isCreateSuccess in
                XCTAssertFalse(isCreateSuccess)
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertFalse(coreDataRepository.isCalledCreateFunction)
        XCTAssertFalse(fileManagerRepository.isCalledCreateFunction)
    }
    
    func test_create_with_invalid_type_then_completion_argument_and_repository_isCalledCreateFunction_is_false() {
        let expectation = XCTestExpectation(description: "Invalid Type Test")
        let invalidTypeDummy = 3
        service.create(
            date: dateDummy,
            type: invalidTypeDummy,
            time: timeDummy,
            data: dataDummy) { isCreateSuccess in
                XCTAssertFalse(isCreateSuccess)
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertFalse(coreDataRepository.isCalledCreateFunction)
        XCTAssertFalse(fileManagerRepository.isCalledCreateFunction)
    }
    
    func test_create_with_invalid_time_then_completion_argument_and_repository_isCalledCreateFunction_is_false() {
        let expectation = XCTestExpectation(description: "Invalid Time Test")
        let invalidTimeDummy = "Wrong Time Dummy"
        service.create(
            date: dateDummy,
            type: typeDummy,
            time: invalidTimeDummy,
            data: dataDummy) { isCreateSuccess in
                XCTAssertFalse(isCreateSuccess)
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertFalse(coreDataRepository.isCalledCreateFunction)
        XCTAssertFalse(fileManagerRepository.isCalledCreateFunction)
    }
    
    func test_create_with_valid_data_then_completion_argument_and_repository_isCalledCreateFunction_is_true() {
        let expectation = XCTestExpectation(description: "Valid Data Test")
        service.create(
            date: dateDummy,
            type: typeDummy,
            time: timeDummy,
            data: dataDummy) { isCreateSuccess in
                XCTAssertTrue(isCreateSuccess)
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertTrue(coreDataRepository.isCalledCreateFunction)
        XCTAssertTrue(fileManagerRepository.isCalledCreateFunction)
    }
}
