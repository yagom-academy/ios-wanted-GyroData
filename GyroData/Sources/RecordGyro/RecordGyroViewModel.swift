//
//  RecordGyroViewModel.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/13.
//

import Combine

final class RecordGyroViewModel {
    private let gyroDataManager = GyroDataManager.shared
    private let gyroRecorder = GyroRecorder.shared
    
    func startRecord(dataTypeRawValue: Int) {
        guard let dataType = GyroData.DataType(rawValue: dataTypeRawValue) else { return }
        
        gyroRecorder.start(dataType: dataType)
    }
    
    func stopRecord() {
        gyroRecorder.stop()
    }
    
    func save() throws {
        guard let data = gyroRecorder.getGyroData() else { return }
        
        do {
            try gyroDataManager.create(data)
        } catch {
            throw error
        }
    }
    
    func gyroRecorderStatusPublisher() -> AnyPublisher<Bool, Never> {
        return gyroRecorder.$isUpdating
            .eraseToAnyPublisher()
    }
    
    func gyroDataPublisher() -> AnyPublisher<GyroData?, Never> {
        return gyroRecorder.gyroDataPublisher()
    }
    
    deinit {
        gyroRecorder.clear()
    }
}
