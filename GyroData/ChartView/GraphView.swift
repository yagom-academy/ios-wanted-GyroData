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
    var data: MeasuredData?
    
    func receive(x: Double, y: Double, z: Double) {

    }
    
    func retrieveData(data: MeasuredData?) {
        self.data = data
    }
}

final class GraphContainerView: UIView {
    private enum Configuration {
        static let borderWidth: CGFloat = 4
        static let edgeDistance: CGFloat = 10
    }
    
    private let chartBackgroundView: GraphBackgroundView = {
        let chartBackgroundView = GraphBackgroundView()
        chartBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        return chartBackgroundView
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
    
    func setupLayouts() {
        NSLayoutConstraint.activate([
            chartBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: Configuration.edgeDistance),
            chartBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Configuration.edgeDistance),
            chartBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Configuration.edgeDistance),
            chartBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Configuration.edgeDistance)
        ])
    }

    func addViews() {
        addSubview(chartBackgroundView)
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
