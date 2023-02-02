//  GyroData - MotionData.swift
//  Created by zhilly, woong on 2023/02/03

import Foundation

struct MotionData: ManagedObjectModel {
    
    var objectID: String?
    var createdAt: Date
    var sensorType: SensorMode
    var runtime: Double
    var sensorData: SensorData
    
    init(objectID: String? = nil,
         createdAt: Date,
         sensorType: SensorMode,
         runtime: Double,
         sensorData: SensorData) {
        self.createdAt = createdAt
        self.sensorType = sensorType
        self.runtime = runtime
        self.sensorData = sensorData
    }
    
    init?(from motionCoreModel: MotionCoreModel) {
        guard let createdAt = motionCoreModel.createdAt else {
            return nil
        }
        
        self.objectID = motionCoreModel.objectID.uriRepresentation().absoluteString
        self.createdAt = createdAt
        self.sensorType = motionCoreModel.sensorMode
        self.runtime = motionCoreModel.runtime
        self.sensorData = SensorData(x: motionCoreModel.xData ?? [Double](),
                                     y: motionCoreModel.yData ?? [Double](),
                                     z: motionCoreModel.zData ?? [Double]()
        )
    }
}
