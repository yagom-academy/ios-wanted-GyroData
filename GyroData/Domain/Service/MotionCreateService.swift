//
//  MotionCreateService.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import Foundation

struct MotionCreateService: MotionCreatable {
    let coreDataRepository: CoreDataRepository
    let fileManagerRepository: FileManagerRepository
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter
    }()
    
    func create(
        date: String,
        type: Int,
        time: String,
        data: [MotionDataType],
        completion: @escaping (Bool) -> Void
    ) {
        DispatchQueue.global().async {
            guard let date = dateFormatter.date(from: date),
                  let type = Motion.MeasurementType(rawValue: type),
                  let time = Double(time)
            else {
                return completion(false)
            }
            
            let data = Motion.MeasurementData(
                x: data.map({ $0.x }),
                y: data.map({ $0.y }),
                z: data.map({ $0.z })
            )
            let motion = Motion(id: UUID().uuidString, date: date, type: type, time: time, data: data)
  
            saveToRepository(motion, completion: completion)
        }
    }
    
    private func saveToRepository(_ motion: Motion, completion: @escaping (Bool) -> Void) {
        var isSuccess: Bool = false
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.global().async(group: dispatchGroup) {
            switch coreDataRepository.create(motion) {
            case .success():
                isSuccess = true
            case .failure(let error):
                print(error.localizedDescription)
                isSuccess = false
            }
        }
        
        DispatchQueue.global().async(group: dispatchGroup) {
            switch fileManagerRepository.create(motion) {
            case .success():
                isSuccess = true
            case .failure(let error):
                print(error.localizedDescription)
                isSuccess = false
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(isSuccess)
        }
    }
}
