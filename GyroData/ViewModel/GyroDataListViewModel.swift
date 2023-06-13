//
//  GyroDataListViewModel.swift
//  GyroData
//
//  Created by 리지 on 2023/06/13.
//

import Foundation
import Combine

final class GyroDataListViewModel {
    @Published private(set) var gyroData: [GyroEntity] = []

}
