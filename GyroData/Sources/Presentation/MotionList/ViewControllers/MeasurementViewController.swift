//
//  MeasurementView.swift
//  GyroData
//
//  Created by 우롱차 on 2022/12/27.
//

import Foundation
import UIKit

final class MeasurementViewController: UIViewController {
    
    private enum Constant {
        static let segmentLeftText = "Acc"
        static let segmentRightText = "Gyro"
        static let measurementButtonText = "측정"
        static let stopButtonText = "정지"
        static let buttonColor = UIColor.blue
    }
    
    //weak var coordinator:
    private let viewModel: MeasermentViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    init(viewModel: MeasermentViewModel) {
        self.viewModel = viewModel
        //self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.currentMotion.observe(on: self) { [weak self] value in
            if let value = value {
                self?.drawGraph(data: value)
            }
        }
    }
    
    private lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [Constant.segmentLeftText, Constant.segmentRightText])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private lazy var graphView: GraphView = {
        let graphView = GraphView()
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.layer.borderWidth = 3
        return graphView
    }()
    
    private lazy var measurementButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.measurementButtonText, for: .normal)
        button.setTitleColor(Constant.buttonColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.stopButtonText, for: .normal)
        button.setTitleColor(Constant.buttonColor, for: .normal)
        button.addTarget(self, action: #selector(startMeasurement(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK - func
    func drawGraph(data: MotionValue) {
        graphView.drawGraph(data: data)
    }
    
    @objc func startMeasurement(_ sender: UIButton) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            viewModel.measerStart(type: .accelerometer)
        case 1:
            viewModel.measerStart(type: .gyro)
        default:
            return
        }
    }
    
    @objc func stopMeasurement(_ sender: UIButton) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            viewModel.measerStop(type: .accelerometer)
        case 1:
            viewModel.measerStart(type: .gyro)
        default:
            return
        }
    }
}

extension MeasurementViewController {
    
    private enum ConstantLayout {
        static let offset: CGFloat = 10
    }
    
    private func setUpView() {
        view.addSubview(segmentControl)
        NSLayoutConstraint.activate([
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstantLayout.offset),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ConstantLayout.offset),
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ConstantLayout.offset)
        ])
        
        view.addSubview(graphView)
        NSLayoutConstraint.activate([
            graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstantLayout.offset),
            graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ConstantLayout.offset),
            graphView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: ConstantLayout.offset),
            graphView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        
        view.addSubview(measurementButton)
        NSLayoutConstraint.activate([
            measurementButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstantLayout.offset),
            measurementButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: ConstantLayout.offset)
        ])
        
        view.addSubview(stopButton)
        NSLayoutConstraint.activate([
            stopButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstantLayout.offset),
            stopButton.topAnchor.constraint(equalTo: measurementButton.bottomAnchor, constant: ConstantLayout.offset)
        ])
    }
}

final class GraphView: UIView {
    
    private var index = 0
    private var previousMotion: MotionValue = MotionValue(timestamp: TimeInterval(), x: 0, y: 0, z: 0)
    
    private enum Constant {
        static let dividCount: Int = 8
        static let lineColor: CGColor = UIColor.gray.cgColor
        static let graphXColor = UIColor.red.cgColor
        static let graphYColor = UIColor.green.cgColor
        static let graphZColor = UIColor.blue.cgColor
        static let lineWidth: CGFloat = 2
        static let graphBaseCount: CGFloat = 8
        static let graphPointersCount: CGFloat = 600
    }
    
    override func draw(_ rect: CGRect) {
            let layer = CAShapeLayer()
            let path = UIBezierPath()
            
            let xOffset = self.frame.width / CGFloat(Constant.dividCount)
            let yOffset = self.frame.height / CGFloat(Constant.dividCount)
            var xpointer: CGFloat = 0
            var ypointer: CGFloat = 0
            let xMaxPointer: CGFloat = self.frame.width
            let yMaxPointer: CGFloat = self.frame.height
        
            var count = 1
            
            while (count < Constant.dividCount) {
                count += 1
                xpointer += xOffset
                path.move(to: CGPoint(x: xpointer, y: 0))
                let newXPosition = CGPoint(x: xpointer, y: yMaxPointer)
                path.addLine(to: newXPosition)

                ypointer += yOffset
                path.move(to: CGPoint(x: 0, y: ypointer))
                let newYPosition = CGPoint(x: xMaxPointer, y: ypointer)
                path.addLine(to: newYPosition)
            }
            
            layer.fillColor = UIColor.black.cgColor
            layer.strokeColor = Constant.lineColor
            layer.lineWidth = 1
            layer.path = path.cgPath
            self.layer.addSublayer(layer)
    }
    
    func drawGraph(data: [MotionValue]) {
        let layerX = CAShapeLayer()
        let layerY = CAShapeLayer()
        let layerZ = CAShapeLayer()
        let pathX = UIBezierPath()
        let pathY = UIBezierPath()
        let pathZ = UIBezierPath()
        
        let offset = self.frame.width / Constant.graphPointersCount
        let initHeight: CGFloat = self.frame.height / 2
        var pointer: CGFloat = 0
        
        pathX.move(to: CGPoint(x: pointer, y: initHeight))
        pathY.move(to: CGPoint(x: pointer, y: initHeight))
        pathZ.move(to: CGPoint(x: pointer, y: initHeight))
        
        for dot in data {
            pointer += offset
            
            let newPositionX = CGPoint(x: pointer, y: initHeight + dot.x)
            let newPositionY = CGPoint(x: pointer, y: initHeight + dot.y)
            let newPositionZ = CGPoint(x: pointer, y: initHeight + dot.z)
            
            pathX.addLine(to: newPositionX)
            pathY.addLine(to: newPositionY)
            pathZ.addLine(to: newPositionZ)
        }
        
        layerX.fillColor = Constant.graphXColor
        layerY.fillColor = Constant.graphYColor
        layerZ.fillColor = Constant.graphZColor
        
        layerX.strokeColor = Constant.graphXColor
        layerY.strokeColor = Constant.graphYColor
        layerZ.strokeColor = Constant.graphZColor
        
        layerX.lineWidth = Constant.lineWidth
        layerY.lineWidth = Constant.lineWidth
        layerZ.lineWidth = Constant.lineWidth
        
        layerX.path = pathX.cgPath
        layerY.path = pathY.cgPath
        layerZ.path = pathZ.cgPath
        
        self.layer.addSublayer(layerX)
        self.layer.addSublayer(layerY)
        self.layer.addSublayer(layerZ)
    }
    
    func drawGraph(data: MotionValue) {
        let layerX = CAShapeLayer()
        let layerY = CAShapeLayer()
        let layerZ = CAShapeLayer()
        let pathX = UIBezierPath()
        let pathY = UIBezierPath()
        let pathZ = UIBezierPath()
        
        let offset = self.frame.width / Constant.graphPointersCount
        let initHeight: CGFloat = self.frame.height / 2
        var pointer: CGFloat = offset * CGFloat(index)
        pathX.move(to: CGPoint(x: pointer, y: initHeight + previousMotion.x))
        pathY.move(to: CGPoint(x: pointer, y: initHeight + previousMotion.y))
        pathZ.move(to: CGPoint(x: pointer, y: initHeight + previousMotion.z))
        
        pointer = offset * CGFloat(index)
        
        let newPositionX = CGPoint(x: pointer, y: initHeight + data.x)
        let newPositionY = CGPoint(x: pointer, y: initHeight + data.y)
        let newPositionZ = CGPoint(x: pointer, y: initHeight + data.z)
        
        pathX.addLine(to: newPositionX)
        pathY.addLine(to: newPositionY)
        pathZ.addLine(to: newPositionZ)
        
        layerX.fillColor = Constant.graphXColor
        layerY.fillColor = Constant.graphYColor
        layerZ.fillColor = Constant.graphZColor
        
        layerX.strokeColor = Constant.graphXColor
        layerY.strokeColor = Constant.graphYColor
        layerZ.strokeColor = Constant.graphZColor
        
        layerX.lineWidth = Constant.lineWidth
        layerY.lineWidth = Constant.lineWidth
        layerZ.lineWidth = Constant.lineWidth
        
        layerX.path = pathX.cgPath
        layerY.path = pathY.cgPath
        layerZ.path = pathZ.cgPath
        
        self.layer.addSublayer(layerX)
        self.layer.addSublayer(layerY)
        self.layer.addSublayer(layerZ)
    }
}
