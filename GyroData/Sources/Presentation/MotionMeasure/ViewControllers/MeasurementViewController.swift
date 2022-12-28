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
    
    weak var coordinator: Coordinator?
    private let viewModel: MeasermentViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        bind()
    }
    
    init(viewModel: MeasermentViewModel, coordinator: Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.currentMotion.observe(on: self) { [weak self] value in
            self?.drawGraph(data: value)
        }
    }
    
    private lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [Constant.segmentLeftText, Constant.segmentRightText])
        control.selectedSegmentIndex = 0
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
        button.addTarget(self, action: #selector(startMeasurement(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.stopButtonText, for: .normal)
        button.setTitleColor(Constant.buttonColor, for: .normal)
        button.addTarget(self, action: #selector(stopMeasurement(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK - func
    func drawGraph(data: MotionValue?) {
        DispatchQueue.main.async {
            self.graphView.drawGraph(data: data)
        }
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
