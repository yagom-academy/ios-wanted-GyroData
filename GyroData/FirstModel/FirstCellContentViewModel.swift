//
//  FirstCellContentViewModel.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//
//testteesttest
import Foundation

class FirstCellContentViewModel {
    //input
    var time: String
    var measureType: String
    var amount: String
    
    //output
    var timeString: String {
        return time
    }
    
    var measureTypeString: String {
        return measureType
    }
    
    var amountString: String {
        return amount
    }
    
    //properties
    
    init() {
        //temp
        self.time = "2022/09/08 14:50:43"
        self.measureType = "gyro"
        self.amount = "60.0"
    }
}
