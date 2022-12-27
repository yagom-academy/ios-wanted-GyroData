//
//  Accelerate.swift
//  GyroData
//
//  Created by unchain, Ellen J, yeton on 2022/12/26.
//

import Foundation

extension Model {
    struct Accelerate: AnalysisType {
        public private(set) var x: Double
        public private(set) var y: Double
        public private(set) var z: Double
        public private(set) var measurementTime: Date
        public private(set) var savedAt: Date
    }
}
