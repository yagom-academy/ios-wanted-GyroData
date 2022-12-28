//
//  GraphView.swift
//  GyroData
//
//  Created by minsson on 2022/12/27.
//

import UIKit

protocol GraphDrawable {
    var data: MeasuredData? { get }
    
    func retrieveData(data: MeasuredData?)
    func startDraw()
    func stopDraw()
    
}

protocol TickReceivable {
    func receive(x: Double, y: Double, z: Double)
}

final class GraphView: UIView, TickReceivable {
    private enum Configuration {
        static var lineColors: [UIColor] = [.red, .green, .blue]
        static let lineWidth: CGFloat = 1
    }
    
    var data: MeasuredData?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GraphView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let measuredData = self.data else {
            return
        }
        
        drawGraph(of: measuredData)
    }
    
    func receive(x: Double, y: Double, z: Double) {
        
    }
    
    func retrieveData(data: MeasuredData?) {
        self.data = data
    }
}

private extension GraphView {
    func drawGraph(of measuredData: MeasuredData) {
        let zeroX: CGFloat = 0
        let zeroY: CGFloat = self.frame.height / CGFloat(2)
        let xInterval = self.frame.width / CGFloat(measuredData.measuredTime * 10)
        
        let sensorData: [[Double]] = [
            measuredData.sensorData.AxisX,
            measuredData.sensorData.AxisY,
            measuredData.sensorData.AxisZ
        ]
        
        sensorData.forEach { eachAxisData in
            let path = UIBezierPath()
            let lineColor: UIColor = Configuration.lineColors.removeFirst()
            
            path.move(to: CGPoint(x: zeroX, y: zeroY))
            path.lineWidth = Configuration.lineWidth
            lineColor.setStroke()
            
            path.drawGraph(strideBy: xInterval, with: eachAxisData, axisY: zeroY)
            path.stroke()
        }
    }
}

final class GraphContainerView: UIView {
    private enum Configuration {
        static let borderWidth: CGFloat = 4
        static let edgeDistance: CGFloat = 10
    }
    
    private let graphBackgroundView: GraphBackgroundView = {
        let graphBackgroundView = GraphBackgroundView()
        graphBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        return graphBackgroundView
    }()
    
    private let graphView: GraphView = {
        let graphView = GraphView()
        graphView.translatesAutoresizingMaskIntoConstraints = false
        
        return graphView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupRootView()
        
        addViews()
        setupLayouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension GraphContainerView {
    func setupRootView() {
        self.backgroundColor = .clear
        self.layer.borderWidth = Configuration.borderWidth
    }
    
    func addViews() {
        addSubview(graphView)
        addSubview(graphBackgroundView)
    }
    
    func setupLayouts() {
        NSLayoutConstraint.activate([
            graphBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: Configuration.edgeDistance),
            graphBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Configuration.edgeDistance),
            graphBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Configuration.edgeDistance),
            graphBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Configuration.edgeDistance),
            
            graphView.topAnchor.constraint(equalTo: graphBackgroundView.topAnchor),
            graphView.bottomAnchor.constraint(equalTo: graphBackgroundView.bottomAnchor),
            graphView.leadingAnchor.constraint(equalTo: graphBackgroundView.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: graphBackgroundView.trailingAnchor)
        ])
    }
}

final class GraphBackgroundView: UIView {
    private enum Configuration {
        static let lineColor = UIColor.black
        static let lineWidth: CGFloat = 1.0
        
        static let numberOfLines = 7
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        drawBackgroundView()
    }
}

private extension GraphBackgroundView {
    func drawBackgroundView() {
        let path = UIBezierPath()
        path.lineWidth = Configuration.lineWidth
        Configuration.lineColor.setStroke()

        let horizontalLineInterval = bounds.height / CGFloat(Configuration.numberOfLines)
        let verticalLineInterval = bounds.width / CGFloat(Configuration.numberOfLines)

        drawHorizontalLines(Configuration.numberOfLines, interval: horizontalLineInterval, with: path)
        drawVerticalLines(Configuration.numberOfLines, interval: verticalLineInterval, with: path)
        
        path.stroke()
    }
    
    func drawHorizontalLines(_ numberOfLines: Int, interval: CGFloat, with path: UIBezierPath) {
        var y: CGFloat = 0.0
        for _ in 0...numberOfLines {
            path.move(to: CGPoint(x: 0.0, y: y))
            path.addLine(to: CGPoint(x: bounds.width, y: y))
            y += interval
        }
    }
    
    func drawVerticalLines(_ numberOfLines: Int, interval: CGFloat, with path: UIBezierPath) {
        var x: CGFloat = 0.0
        for _ in 0...numberOfLines {
            path.move(to: CGPoint(x: x, y: 0.0))
            path.addLine(to: CGPoint(x: x, y: bounds.height))
            x += interval
        }
    }
}
