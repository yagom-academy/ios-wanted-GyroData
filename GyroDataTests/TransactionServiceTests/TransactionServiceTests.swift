//
//  TransactionServiceTests.swift
//  GyroDataTests
//
//  Created by 이정민 on 2023/01/31.
//

import XCTest

final class TransactionServiceTests: XCTestCase {
    
    var transactionService: TransactionService!
    var coreDataManagerStub: DataManageable!
    var fileManagerStub: FileManageable!
    let dummys = MeasureDataDummy.Dummys
    
    override func setUpWithError() throws {
        coreDataManagerStub = CoreDataManagerStub()
        fileManagerStub = FileSystemManagerStub()
        
        transactionService = TransactionService(
            coreDataManager: coreDataManagerStub,
            fileManager: fileManagerStub
        )
    }
    
    func test_save_and_fetch_data_success() {
        // given
        let decoder = JSONDecoder()
        
        dummys.forEach({
            transactionService.save(data: $0)
        })
        
        // when
        let measureData = transactionService.dataLoad(offset: 0, limit: 0)
        let jsonData = transactionService.jsonDataLoad(date: Date())
        
        // then
        switch measureData {
        case .success(let dataList):
            for i in 0..<dataList.count {
                XCTAssertEqual(dataList[i].date, dummys[i].date)
            }
        case .failure(_):
            XCTFail()
        }
        
        switch jsonData {
        case .success(let jsonData):
            do {
                let model = try decoder.decode(MeasureData.self, from: jsonData)
                XCTAssertEqual(model.date, dummys[0].date)
            } catch {
                XCTFail()
            }
        case .failure(_):
            XCTFail()
        }
    }
    
    func test_delete_data_success() {
        // given
        dummys.forEach({
            transactionService.save(data: $0)
        })
        
        // when
        transactionService.delete(date: dummys[0].date)
        
        // then
        let measureData = transactionService.dataLoad(offset: 0, limit: 0)
        
        switch measureData {
        case .success(let dataList):
            XCTAssertEqual(dataList.count, dummys.count - 1)
        case .failure(_):
            XCTFail()
        }
    }
}
