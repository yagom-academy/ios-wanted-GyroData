import UIKit

class GraphView: UIView {
    
    var dataSource: GraphViewDataSource?
    var linePaths: [UIBezierPath] = []
    
    override func draw(_ rect: CGRect) {
        UIColor.systemGray.setStroke()
        let xAxisPath = UIBezierPath()
        xAxisPath.lineWidth = 1
        xAxisPath.move(to: CGPoint(x: rect.origin.x, y: rect.midY))
        xAxisPath.addLine(to: CGPoint(x: rect.origin.x + rect.width, y: rect.midY))
        xAxisPath.stroke()
        
        guard let numberOfLines = dataSource?.numberOfLines(graphView: self),
              let colorOfLines = dataSource?.colorOfLines(graphView: self),
              let dataList = dataSource?.dataList(graphView: self),
              let maximumXValueCount = dataSource?.maximumXValueCount(graphView: self) else {
            return
        }
        
        linePaths = []
        
        for index in 0..<numberOfLines {
            let linePath = UIBezierPath()
            linePath.lineWidth = 1
            linePaths.append(linePath)
            drawLines(rect,
                      color: colorOfLines[index],
                      dataList: dataList[index],
                      maximumXValueCount: maximumXValueCount,
                      linePath: linePaths[index])
        }
    }
    
    private func drawLines(_ rect: CGRect,
                           color: UIColor,
                           dataList: [Double],
                           maximumXValueCount: CGFloat,
                           linePath: UIBezierPath) {
        
        var xValue: CGFloat = 0
        let yValueList = dataList.map { yValue in
            rect.midY - CGFloat(yValue) * 10
        }
        let spacing = rect.width / maximumXValueCount
        color.setStroke()
        yValueList.forEach { yValue in
            let point = CGPoint(x: xValue, y: yValue)
            if linePath.isEmpty {
                linePath.move(to: point)
            } else {
                linePath.addLine(to: point)
            }
            xValue += spacing
        }
        linePath.stroke()
    }
}
