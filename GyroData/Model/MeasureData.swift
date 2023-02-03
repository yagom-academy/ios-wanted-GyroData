//
//  MeasureData.swift
//  GyroData
//
//  Created by stone, LJ on 2023/01/31.
//

import Foundation
import CoreMotion

protocol MeasureData: AnyObject { }

extension CMAccelerometerData: MeasureData { }
extension CMGyroData: MeasureData { }
