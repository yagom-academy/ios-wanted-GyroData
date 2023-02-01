//
//  GraphView.swift
//  GyroData
//
//  Created by Baem, Dragon on 2023/02/01.
//

import UIKit

class GraphView: UIView {
    private let dataLinePath = UIBezierPath()
    private var dataListX = [Double]()
    private var dataListY = [Double]()
    private var dataListZ = [Double]()
    private let dataXLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.text = "x:0"
        return label
    }()
    private let dataYLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.text = "y:0"
        return label
    }()
    private let dataZLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.text = "z:0"
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        startDrawLines(rect)
    }
    
    func stopDrawLines() {
        dataListX.removeAll()
        dataListY.removeAll()
        dataListZ.removeAll()
        
        dataLinePath.removeAllPoints()
        
        configureLabelText()
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
        
        dataXLabel.text = "x:" + String(kiloDataX)
        dataYLabel.text = "y:" + String(kiloDataY)
        dataZLabel.text = "z:" + String(kiloDataZ)
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
        let xInterval = rect.width / 600
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
    
    func clear() {
        dataListX = .init()
        dataListY = .init()
        dataListZ = .init()
    }
    
    func totalData(data: [MotionData]) {
        
        data.forEach { motionDatas in
            dataListX.append(motionDatas.x)
            dataListY.append(motionDatas.y)
            dataListZ.append(motionDatas.z)
        }
        
        setNeedsDisplay()
    }
}
