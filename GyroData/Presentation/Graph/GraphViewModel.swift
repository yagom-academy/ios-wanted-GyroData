//
//  GraphViewModel.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/27.
//

import UIKit

final class GraphViewModel {
    var xScale: CGFloat = 600
    var yScale: CGFloat = 60
    var horizontalBackgroundSlice = 8
    var verticalBackgroundSlice = 8

    var pastValueForRed = [Double]()
    var pastValueForBlue = [Double]()
    var pastValueForGreen = [Double]()
}
