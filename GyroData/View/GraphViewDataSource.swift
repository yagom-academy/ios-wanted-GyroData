//
//  GraphViewDataSource.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/02/02.
//

import UIKit

protocol GraphViewDataSource {
    
    func numberOfLines(graphView: GraphView) -> Int
    func colorOfLines(graphView: GraphView) -> [UIColor]
    func dataList(graphView: GraphView) -> [[Double]]
    func maximumXValueCount(graphView: GraphView) -> CGFloat
}
