//
//  CoreMotionRepositorable.swift
//  GyroData
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

protocol CoreMotionRepositorable {
    func startAccelerometer(_ completion: @escaping (MotionCoordinates) -> Void)
    func startGyroscope(completion: @escaping (MotionCoordinates) -> Void)
    func stopAccelerometer()
    func stopGyroscope()
}
