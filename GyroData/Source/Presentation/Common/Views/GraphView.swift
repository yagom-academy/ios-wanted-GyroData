//
//  GraphView.swift
//  GyroData
//
//  Created by 이정민 on 2023/02/02.
//

import UIKit

class SampleViewController: UIViewController {
    let graphView: GraphView = {
        let graphView = GraphView(interval: 0.1, duration: 60)
        graphView.backgroundColor = .systemGray6
        graphView.translatesAutoresizingMaskIntoConstraints = false
        return graphView
    }()
    
    override func viewDidLoad() {
        view.addSubview(graphView)
        
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            graphView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            graphView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor)
        ])
    }
}

class GraphView: UIView {
    typealias Values = (x: Double, y: Double, z: Double)
    typealias Positions = (x: Double, y: Double, z: Double)
    
    private var segmentValues: [Values] = []
    private var segmentPositions: [Positions] = []
    private let segmentOffset: Double
    
    private let interval: TimeInterval
    private let duration: TimeInterval
    
    private var boundary: Double
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let xLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .current)
        label.text = "x : -1.234"
        
        return label
    }()
    
    private let yLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .current)
        label.text = "y : -1.234"
        return label
    }()
    
    private let zLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .current)
        label.text = "z : -1.234"
        return label
    }()
    
    init(interval: TimeInterval, duration: TimeInterval) {
        self.interval = interval
        self.duration = duration
        self.segmentOffset = duration / interval
        self.boundary = 4
        super.init(frame: .zero)
        
        setupStackView()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupBaseLine()
        self.bringSubviewToFront(labelStackView)
        
        drawData(data: (100, 200, 300))
    }
    
    func drawData(data: Values) {
        let xPath = UIBezierPath()
        let yPath = UIBezierPath()
        let zPath = UIBezierPath()
        
        let lastValues = segmentValues.last ?? (0, 0, 0)
        let convertedValues = mappingToFrame(values: lastValues)
        let lastPosition = (Double(segmentValues.count) * segmentOffset)
        
        let xStartPoint = CGPoint(x: lastPosition, y: convertedValues.x)
        let xEndPoint = CGPoint(x: lastPosition + segmentOffset, y: data.x)
        
        let yStartPoint = CGPoint(x: lastPosition, y: convertedValues.y)
        let yEndPoint = CGPoint(x: lastPosition + segmentOffset, y: data.y)
        
        let zStartPoint = CGPoint(x: lastPosition, y: convertedValues.z)
        let zEndPoint = CGPoint(x: lastPosition + segmentOffset, y: data.z)
        
        UIColor.systemRed.setStroke()
        xPath.move(to: xStartPoint)
        xPath.addLine(to: xEndPoint)
        xPath.stroke()
        
        UIColor.systemGreen.setStroke()
        yPath.move(to: yStartPoint)
        yPath.addLine(to: yEndPoint)
        yPath.stroke()
        
        UIColor.systemBlue.setStroke()
        zPath.move(to: zStartPoint)
        zPath.addLine(to: zEndPoint)
        zPath.stroke()
        
        segmentValues.append(data)
    }
}

private extension GraphView {
    func setupStackView() {
        self.addSubview(labelStackView)
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:  8),
            labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
        ])
        
        [xLabel, yLabel, zLabel].forEach { labelStackView.addArrangedSubview($0) }
    }
    
    func setupBaseLine() {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        
        let lineCount = 8
        let xOffset = self.frame.width / CGFloat(lineCount)
        let yOffset = self.frame.height / CGFloat(lineCount)
        var xpointer: CGFloat = .zero
        var ypointer: CGFloat = .zero
        let width: CGFloat = self.frame.width
        let height: CGFloat = self.frame.height
        
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.systemGray2.cgColor
        
        Array(1...lineCount).forEach { _ in
            xpointer += xOffset
            path.move(to: CGPoint(x: xpointer, y: 0))
            let newXPosition = CGPoint(x: xpointer, y: height)
            path.addLine(to: newXPosition)
            
            ypointer += yOffset
            path.move(to: CGPoint(x: 0, y: ypointer))
            let newYPosition = CGPoint(x: width, y: ypointer)
            path.addLine(to: newYPosition)
        }
        
        layer.fillColor = UIColor.gray.cgColor
        layer.strokeColor = UIColor.gray.cgColor
        layer.lineWidth = 1
        layer.path = path.cgPath
        
        self.layer.addSublayer(layer)
    }
    
    func mappingToFrame(values: Values) -> Values {
        let mappingValues = [values.x, values.y, values.z].map {
            let mappingValue = $0 / (boundary * 2)
            let positionFromFrame = (self.frame.height / 2.0) - mappingValue
            
            return positionFromFrame
        }
        
        return (mappingValues[0], mappingValues[1], mappingValues[2])
    }
}

















































import SwiftUI

struct PreView: PreviewProvider {
    static var previews: some View {
        SampleViewController().toPreview()
    }
}


#if DEBUG
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif
