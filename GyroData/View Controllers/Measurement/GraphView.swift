//
//  GraphView.swift
//  GyroData
//
//  Created by 신병기 on 2022/09/26.
//

import UIKit

class GraphView: UIView {
    var width: Double?
    var height: Double?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.width = frame.width
        self.height = frame.height
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        guard let width = self.width else { return }
        guard let height = self.height else { return }
        let interval = height / 10
        
        for line in 1...10 {
            path.move(to: CGPoint(x: 0, y: Double(line) * interval))
            path.addLine(to: CGPoint(x: width, y: Double(line) * interval))
            
            path.move(to: CGPoint(x: Double(line) * interval, y: 0))
            path.addLine(to: CGPoint(x: Double(line) * interval, y: height))
        }
        
        UIColor.systemGray3.set()
        path.stroke()
    }
}
