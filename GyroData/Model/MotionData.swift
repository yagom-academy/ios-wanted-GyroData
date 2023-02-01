//
//  File.swift
//  GyroData
//
//  Created by stone, LJ on 2023/01/31.
//

import Foundation
import CoreMotion

protocol MotionData: AnyObject { }

extension CMAccelerometerData: MotionData { }
extension CMGyroData: MotionData { }
