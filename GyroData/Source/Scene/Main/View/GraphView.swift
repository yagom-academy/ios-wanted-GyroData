//
//  GraphView.swift
//  GyroData
//
//  Created by Baem, Dragon on 2023/02/01.
//

import UIKit

class GraphView: UIView {
    
    // MARK: Internal Properties
    
    var motionDatas: MotionData? {
        didSet {
            guard let motionDatas = motionDatas else { return }
            
            configureLabelText(dataX: motionDatas.x, dataY: motionDatas.y, dataZ: motionDatas.z)
            
            dataListX.append(motionDatas.x)
            dataListY.append(motionDatas.y)
            dataListZ.append(motionDatas.z)
            
            setNeedsDisplay()
        }
    }
    
    // MARK: Private Properties
    
    private var graphXSize: CGFloat = 600
    private var dataListX = [Double]()
    private var dataListY = [Double]()
    private var dataListZ = [Double]()
    
    private let dataXLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.text = NameSpace.initialDataXLabelText
        return label
    }()
    private let dataYLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.text = NameSpace.initialDataYLabelText
        return label
    }()
    private let dataZLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.text = NameSpace.initialDataZLabelText
        return label
    }()
    private let dataLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureLayout()
    }
    
    override func draw(_ rect: CGRect) {
        startDrawLines(rect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal Methods
    
    func stopDrawLines() {
        dataListX.removeAll()
        dataListY.removeAll()
        dataListZ.removeAll()
        
        configureLabelText()
    }
    
    func clearData() {
        dataListX = .init()
        dataListY = .init()
        dataListZ = .init()
    }
    
    func changeGraphXSize(graphXSize: CGFloat) {
        self.graphXSize = graphXSize * 10
    }
    
    // MARK: Private Methods
    
    private func configureView() {
        backgroundColor = .systemBackground
        
        layer.borderWidth = 3
        layer.borderColor = UIColor.black.cgColor
    }
    
    private func setUpStackView() {
        dataLabelStackView.addArrangedSubview(dataXLabel)
        dataLabelStackView.addArrangedSubview(dataYLabel)
        dataLabelStackView.addArrangedSubview(dataZLabel)
    }
    
    private func configureLayout() {
        setUpStackView()
        
        addSubview(dataLabelStackView)
        
        NSLayoutConstraint.activate([
            dataLabelStackView.widthAnchor.constraint(
                equalTo: widthAnchor,
                multiplier: 0.85
            ),
            dataLabelStackView.heightAnchor.constraint(
                equalTo: heightAnchor,
                multiplier: 0.15
            ),
            dataLabelStackView.topAnchor.constraint(equalTo: topAnchor),
            dataLabelStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func startDrawLines(_ rect: CGRect) {
        drawMeasureLines(rect)

        drawDataLines(rect, color: .red, dataList: dataListX)
        drawDataLines(rect, color: .blue, dataList: dataListY)
        drawDataLines(rect, color: .green, dataList: dataListZ)
    }
    
    private func configureLabelText(dataX: Double = 0, dataY: Double = 0, dataZ: Double = 0) {
        let kilo = 1000.0
        let kiloDataX = Int(dataX * kilo)
        let kiloDataY = Int(dataY * kilo)
        let kiloDataZ = Int(dataZ * kilo)
        
        dataXLabel.text = NameSpace.dataXLabelText + String(kiloDataX)
        dataYLabel.text = NameSpace.dataYLabelText + String(kiloDataY)
        dataZLabel.text = NameSpace.dataZLabelText + String(kiloDataZ)
    }
    
    private func drawMeasureLines(_ rect: CGRect) {
        let measureLinePath = UIBezierPath()
        
        for ratio in 1...8 {
            measureLinePath.move(
                to: CGPoint(
                    x: rect.origin.x,
                    y: rect.maxY - (rect.maxY / CGFloat(8)) * CGFloat(ratio)
                )
            )
            measureLinePath.addLine(
                to: CGPoint(
                    x: rect.origin.x + rect.width,
                    y: rect.maxY - (rect.maxY / CGFloat(8)) * CGFloat(ratio)
                )
            )
            measureLinePath.close()
            
            measureLinePath.move(
                to: CGPoint(
                    x: rect.maxX - (rect.maxX / CGFloat(8)) * CGFloat(ratio),
                    y: rect.origin.y
                )
            )
            measureLinePath.addLine(
                to: CGPoint(
                    x: rect.maxX - (rect.maxX / CGFloat(8)) * CGFloat(ratio),
                    y: rect.origin.y + rect.height
                )
            )
            measureLinePath.close()
        }
        
        UIColor.systemGray.setStroke()
        
        measureLinePath.lineWidth = 1
        measureLinePath.stroke()
    }
    
    private func drawDataLines(_ rect: CGRect, color: UIColor, dataList: [Double]) {
        let ratioDataList = dataList.map { value in
            rect.midY - CGFloat(value) * 10
        }
        var xPosition: CGFloat = 0
        let xInterval = rect.width / graphXSize
        let linePath = UIBezierPath()
        
        color.setStroke()
        linePath.lineWidth = 1
        
        ratioDataList.forEach({ value in
            let point = CGPoint(x: xPosition, y: value)
            
            if linePath.isEmpty {
                linePath.move(to: point)
            } else {
                linePath.addLine(to: point)
            }
            
            xPosition += xInterval
        })
        
        linePath.stroke()
    }
}

// MARK: - NameSpace

private enum NameSpace {
    static let initialDataXLabelText = "x:0"
    static let initialDataYLabelText = "y:0"
    static let initialDataZLabelText = "z:0"
    static let dataXLabelText = "x:"
    static let dataYLabelText = "y:"
    static let dataZLabelText = "z:"
}
