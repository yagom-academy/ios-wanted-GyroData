//
//  FileManagerMotionReadServiceTests.swift
//  GyroDataTests
//
//  Created by Ayaan, Wonbi on 2023/02/01.
//

import XCTest
@testable import GyroData

final class FileManagerMotionReadServiceTests: XCTestCase {
    var fileManagerRepository: FileManagerRepositoryMock!
    var service: GyroData.FileManagerMotionReadService<FileManagerRepositoryMock>!

    override func setUpWithError() throws {
        fileManagerRepository = FileManagerRepositoryMock()
        service = GyroData.FileManagerMotionReadService(repository: fileManagerRepository)
    }

    override func tearDownWithError() throws {
        fileManagerRepository = nil
        service = nil
    }

    func test_Service의Read메서드를호출했을때_Repository의read메서드가호출되는지() {
        // given
        let _ = service.read(with: "")
        
        // when
        let isReadCalled = service.repository.isCalledReadFunction
        let isCreateCalled = service.repository.isCalledCreateFunction
        let isDeleteCalled = service.repository.isCalledDeleteFunction
        
        // then
        XCTAssertEqual(true, isReadCalled)
        XCTAssertEqual(false, isCreateCalled)
        XCTAssertEqual(false, isDeleteCalled)
    }
}
