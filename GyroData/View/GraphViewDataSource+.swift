//
//  GraphViewDataSource+.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/02/02.
//

import UIKit

extension GraphViewDataSource {
    
    func numberOfLines(graphView: GraphView) -> Int {
        return 3
    }
    
    func colorOfLines(graphView: GraphView) -> [UIColor] {
        return [.red, .green, .blue]
    }
}
