//
//  MotionDeleteServiceTests.swift
//  GyroDataTests
//
//  Created by Ayaan, Wonbi on 2023/02/01.
//

import XCTest
@testable import GyroData

final class MotionDeleteServiceTests: XCTestCase {
    var coreDataRepository: CoreDataRepositoryMock!
    var fileManagerRepository: FileManagerRepositoryMock!
    var service: GyroData.MotionDeleteService!

    override func setUpWithError() throws {
        coreDataRepository = CoreDataRepositoryMock()
        fileManagerRepository = FileManagerRepositoryMock()
        service = GyroData.MotionDeleteService(
            coreDataRepository: coreDataRepository,
            fileManagerRepository: fileManagerRepository
        )
    }

    override func tearDownWithError() throws {
        coreDataRepository = nil
        fileManagerRepository = nil
        service = nil
    }

    func test_Service의delete메서드를호출했을때_Repository의delete메서드들이호출되는지() {
        // given
        let _ = service.delete("")
        
        // when
        let isCoreDataDeleteCalled = coreDataRepository.isCalledDeleteFunction
        let isFileManagerDeleteCalled = fileManagerRepository.isCalledDeleteFunction
        
        // then
        XCTAssertEqual(true, isCoreDataDeleteCalled)
        XCTAssertEqual(true, isFileManagerDeleteCalled)
    }
}
