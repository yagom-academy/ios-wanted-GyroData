//
//  CoreDataMotionReadServiceTests.swift
//  GyroDataTests
//
//  Created by Ayaan, Wonbi on 2023/02/01.
//

import XCTest

@testable import GyroData

final class CoreDataMotionReadServiceTests: XCTestCase {
    var coreDataRepository: CoreDataRepositoryMock!
    var service: CoreDataMotionReadService!

    override func setUpWithError() throws {
        coreDataRepository = CoreDataRepositoryMock()
        service = CoreDataMotionReadService(coreDataRepository: coreDataRepository)
    }

    override func tearDownWithError() throws {
        coreDataRepository = nil
        service = nil
    }

    func test_read_from_10_then_repository_isCalledReadFunction_is_true() {
        //given
        let offset = 10
        
        //when
        let result = service.read(from: offset)
        
        //then
        XCTAssertNotNil(result)
        XCTAssertTrue(coreDataRepository.isCalledReadFunction)
    }
}
