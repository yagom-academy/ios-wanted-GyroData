//
//  MeasureViewController.swift
//  GyroData
//
//  Created by Tak on 2022/12/28.
//

import UIKit

class MeasureViewController: UIViewController {
    
    let viewModel = MeasureViewModel()
    var graphView = GraphView()

    private let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: SensorType.allCases.map({ $0.rawValue }))
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        return control
    }()
    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveRecord(_:)))
        button.isEnabled = false
        return button
    }()
    private lazy var recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("측정", for: .normal)
        button.addTarget(self, action: #selector(recordButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var pauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("정지", for: .normal)
        button.addTarget(self, action: #selector(pauseButtonTapped(_:)), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "측정하기"
        self.navigationItem.rightBarButtonItem = self.saveButton
        setSegment()
        pauseButtonLayout()
        recordButtonLayout()
        graphViewLayout()
        bind()
    }
    
    private func setSegment() {
        segmentLayout()
        for index in 0..<SensorType.allCases.count {
            segmentControl.setWidth(self.view.frame.width / 3, forSegmentAt: index)
        }
        segmentControl.addTarget(self, action: #selector(changeTypeOfMeasurement(_:)), for: .valueChanged)
    }
    
    private func segmentLayout() {
        view.addSubview(segmentControl)
        NSLayoutConstraint.activate([
            segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    private func recordButtonLayout() {
        view.addSubview(recordButton)
        NSLayoutConstraint.activate([
            recordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            recordButton.bottomAnchor.constraint(equalTo: pauseButton.topAnchor, constant: -30)
        ])
    }
    
    private func pauseButtonLayout() {
        view.addSubview(pauseButton)
        NSLayoutConstraint.activate([
            pauseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            pauseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    }
    
    func createGraphLayer(values: [CGFloat], color: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        
        var currentX: CGFloat = 10
        
        let xOffset = self.view.frame.width / CGFloat(values.count)
        
        let centerY = self.view.frame.height / 2
        
        let centerYPosition = CGPoint(x: currentX, y: centerY)
        path.move(to: centerYPosition)
        
        for i in 0..<values.count {
            currentX += xOffset
            path.addLine(to: CGPoint(x: currentX, y: centerY - values[i]))
        }
        
        layer.fillColor = nil
        layer.strokeColor = color.cgColor
        layer.lineWidth = 2
        layer.path = path.cgPath
        
        return layer
    }
    
    func bind() {
        viewModel.gyroItem.subscribe { gyroItem in
            guard let x = gyroItem.x,
                  let y = gyroItem.y,
                  let z = gyroItem.z else { return }
            let graphX = self.createGraphLayer(values: x, color: .red)
            let graphY = self.createGraphLayer(values: y, color: .green)
            let graphZ = self.createGraphLayer(values: z, color: .blue)
            
            [graphX, graphY, graphZ].forEach {
                self.graphView.layer.addSublayer($0)
            }
        }
    }
    
    private func graphViewLayout() {
        let frame = CGRect(x: self.view.frame.width / 10, y: self.view.frame.height / 4, width: self.view.frame.width * (4/5), height: self.view.frame.width * (4/5))
        let graphView = GraphView()
        view.addSubview(graphView)
        graphView.frame = frame
        graphView.layer.borderColor = UIColor.black.cgColor
        graphView.layer.borderWidth = 3
    }
    
    @objc private func changeTypeOfMeasurement(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            print("acc mode") // case 0 acc일때 graphView
        case 1:
            print("gyro mode")// case 0 gyro일때 grapgView
        default:
            return
        }
    }
    
    @objc private func recordButtonTapped(_ sender: UIButton) {
        pauseButton.isEnabled = true
        viewModel.onStart()
    }
    
    @objc private func pauseButtonTapped(_ sender: UIButton) {
        pauseButton.isEnabled = false
        viewModel.onStop()
    }
    
    @objc private func saveRecord(_ sender: Any) {
        // 저장 로직 구현?
        self.navigationController?.popViewController(animated: true)
    }
}

enum SensorType: String, CaseIterable {
    case acceleromter = "Acc"
    case gyro = "Gyro"
}
