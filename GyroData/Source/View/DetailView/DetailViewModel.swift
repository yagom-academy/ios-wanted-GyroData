//  GyroData - DetailViewModel.swift
//  Created by zhilly, woong on 2023/02/04

import Foundation

class DetailViewModel {
    let model: Observable<FileManagedData> = .init(FileManagedData(createdAt: Date(),
                                                                   runtime: 0.0,
                                                                   sensorData: .init(x: [],
                                                                                     y: [],
                                                                                     z: [])))
    var runtime: Observable<Double> = .init(0)
    private var timer: Timer?
    private var index: Int = 0
    
    init(date: Date) {
        guard let data = fetch(createdAt: date) else { return }
        self.model.value = data
    }
    
    private func fetch(createdAt: Date) -> FileManagedData? {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else { return nil }
        var filePath = URL(fileURLWithPath: path)
        let convertedDate = DateFormatter.convertToFileFormat(date: createdAt)
        let appendPathJsonComponent = convertedDate + ".json"
        filePath.appendPathComponent(appendPathJsonComponent)
        
        if let data = try? Data(contentsOf: filePath) {
            if let dataToJson = try? JSONDecoder().decode(FileManagedData.self, from: data) {
                return dataToJson
            }
        }
        return nil
    }
    
    func startDraw(completion: @escaping (_ x: Double?, _ y: Double?, _ z: Double?) -> Void) {
                
        self.timer = Timer(fire: Date(),
                           interval: (10.0 / 60),
                           repeats: true,
                           block: { timer in
            self.runtime.value += 0.1

            if self.runtime.value >= self.model.value.runtime {
                self.stopDraw()
            }
            
            completion(self.model.value.sensorData.x[safe: self.index],
                       self.model.value.sensorData.y[safe: self.index],
                       self.model.value.sensorData.z[safe: self.index])
            
            self.index += 1
        })
        
        RunLoop.current.add(self.timer ?? Timer(), forMode: .default)
    }
    
    func stopDraw() {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    func reset() {
        self.timer = nil
        self.index = 0
        self.runtime.value = 0
    }
}
