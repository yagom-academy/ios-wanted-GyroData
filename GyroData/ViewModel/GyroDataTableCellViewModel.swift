//
//  GyroDataTableCellViewModel.swift
//  GyroData
//
//  Created by 리지 on 2023/06/12.
//

import Combine
import Foundation

final class GyroDataTableCellViewModel {
    @Published private(set) var sixAxisData: GyroEntity
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"

        return dateFormatter
    }()
    
    private let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .halfUp
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.maximumFractionDigits = 1
        
        return numberFormatter
    }()
    
    init(sixAxisData: GyroEntity) {
        self.sixAxisData = sixAxisData
    }
    
    var date: String? {
        guard let date = sixAxisData.date else { return nil }
        let convertedDate = dateFormatter.string(from: date)
        return convertedDate
    }
    
    var title: String? {
        guard let title = sixAxisData.title else { return nil }
        return title
    }
    
    var recordTitle: String? {
        let recordTime = sixAxisData.recordTime
        guard let convertedTime = numberFormatter.string(from: NSNumber(value: recordTime)) else { return nil }
        return String(describing: convertedTime)
    }
}

