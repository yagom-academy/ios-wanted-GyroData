//
//  MeasureViewModel.swift
//  GyroData
//
//  Created by TORI on 2022/12/30.
//

import Foundation

final class MeasureViewModel {
    
    private let manager = CoreMotionManager()
    var gyroItem = Observable(GyroItem(x: [], y: [], z: []))
    
    func onStart() {
        manager.startGyros { [weak self] x, y, z in
            self?.gyroItem.value.x?.append(x)
            self?.gyroItem.value.y?.append(y)
            self?.gyroItem.value.z?.append(z)
        }
    }
    
    func onStop() {
        manager.stopGyros()
    }
}
