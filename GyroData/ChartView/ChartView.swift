//
//  ChartView.swift
//  GyroData
//
//  Created by minsson on 2022/12/27.
//

protocol ChartDrawable {
    var data: MeasuredData? { get }
    
    func retrieveData(data: MeasuredData?)
    func startDraw()
    func stopDraw()
    
}

protocol TickReceivable {
    func receive(x: Double, y: Double, z: Double)
}

final class ChartView: TickReceivable {
    var data: MeasuredData?
    
    func receive(x: Double, y: Double, z: Double) {

    }
    
    func retrieveData(data: MeasuredData?) {
        self.data = data
    }
}
