//  GyroData - GraphView.swift
//  Created by zhilly, woong on 2023/02/01

import UIKit

class GraphView: UIView {
    
    override func draw(_ rect: CGRect) {
        drawGrid()
        drawGraph()
    }
    
    private func drawGrid() {
        let gridWidth = self.frame.size.width / 6
        let gridPath = UIBezierPath()
        
        var pointLeft = CGPoint(x: 0, y: gridWidth)
        var pointRight = CGPoint(x: bounds.size.width, y: gridWidth)
        while pointLeft.y < bounds.height {
            gridPath.move(to: pointLeft)
            gridPath.addLine(to: pointRight)
            pointLeft.y = pointLeft.y + gridWidth
            pointRight.y = pointRight.y + gridWidth
        }
        
        var pointTop = CGPoint(x: gridWidth, y: 0)
        var pointBottom = CGPoint(x: gridWidth, y: bounds.size.height)
        while pointTop.x < bounds.width {
            gridPath.move(to: pointTop)
            gridPath.addLine(to: pointBottom)
            pointTop.x = pointTop.x + gridWidth
            pointBottom.x = pointBottom.x + gridWidth
        }
        
        let gridLayer = CAShapeLayer()
        gridLayer.frame = bounds
        gridLayer.path = gridPath.cgPath
        gridLayer.strokeColor = UIColor.black.cgColor
        gridLayer.lineWidth = 0.4
        layer.addSublayer(gridLayer)
    }
    
    private func drawGraph() {
        let path = UIBezierPath()
        let data = Sample.data
        let widthSize: Double = Double(self.frame.size.width / 60)
        var startX: Double = 0
        
        path.lineWidth = 1
        path.lineJoinStyle = .miter
        path.usesEvenOddFillRule = true
        UIColor.systemBlue.set()
        path.move(to: CGPoint(x: startX, y: convertDrawingData(item: data[0][0])))
        
        for item in data {
            let yData = convertDrawingData(item: item[0])
            path.addLine(to: CGPoint(x: startX, y: yData))
            startX += widthSize
        }
        path.stroke()
    }
    
    private func convertDrawingData(item: Double) -> Double {
        
        return ((item * -1) * 30) + Double(self.frame.size.height / 2)
    }
}

struct Sample {
    static let data = [
        [-0.5150604248046875, 0.1401749551296234, 0.03935060277581215],
        [-0.8111445307731628, 0.04406679421663284, 0.11446985602378845],
        [-2.0174763202667236, 0.020430706441402435, 0.07496026158332825],
        [-2.058032512664795, 0.11670078337192535, 0.8893663883209229],
        [-0.1554282009601593, -0.3796258866786957, -0.0874696597456932],
        [-0.005259210709482431, 0.04111707583069801, 0.02919144183397293],
        [0.058949071913957596, 0.06258002668619156, 0.023319438099861145],
        [0.026391128078103065, 0.11537425965070724, 0.07539941370487213],
        [0.013614345341920853, 0.03219575434923172, 0.002555303042754531],
        [0.09562478959560394, 0.04627881571650505, -0.018223479390144348],
        [0.38694825768470764, 0.21574054658412933, 0.04741571843624115],
        [0.8504748940467834, 0.00956527516245842, -0.0410933755338192],
        [1.5219273567199707, 0.08657750487327576, -0.06619686633348465],
        [1.5831142663955688, -0.06643494963645935, -0.16843454539775848],
        [0.9542306065559387, 0.049914028495550156, -0.12472169101238251],
        [0.8263500928878784, -0.06336698681116104, -0.08399663120508194],
        [0.8193897008895874, -0.03412947431206703, -0.03740542754530907],
        [0.7770161032676697, -0.14043274521827698, -0.0020546286832541227],
        [0.44278833270072937, 0.008415322750806808, -0.032339032739400864],
        [0.6481071710586548, -0.05842868983745575, 0.014563762582838535],
        [0.5263152122497559, 0.01642025262117386, -0.009068063460290432],
        [0.29645857214927673, -0.07203558087348938, 0.01248117070645094],
        [0.46340546011924744, -0.028716865926980972, 0.02370559610426426],
        [0.9292413592338562, -0.05639003962278366, 0.004605670925229788],
        [0.9977037310600281, -0.17154325544834137, 0.10098174214363098],
        [2.266471266746521, -0.3094513416290283, 0.1607753038406372],
        [3.1059695482254028, 0.05789126455783844, -0.18275196850299835],
        [3.17573587596416473, 0.010057694278657436, -0.07588464766740799],
        [0.05863188952207565, 0.016640761867165565, -0.008612928912043571],
        [-0.9615862369537354, 0.12606152892112732, 0.12351314723491669],
        [-1.717890977859497, 0.1064809039235115, 0.1389155387878418],
        [-2.1726908683776855, 0.03045590966939926, 0.13939784467220306],
        [-2.0706288814544678, -0.14872689545154572, -0.05303205922245979],
        [-0.4790683090686798, 0.21095457673072815, -0.021350296214222908]
    ]
}
