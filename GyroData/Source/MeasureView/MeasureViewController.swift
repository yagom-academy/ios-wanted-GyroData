//  GyroData - MeasureViewController.swift
//  Created by zhilly, woong on 2023/01/31

import UIKit

final class MeasureViewController: UIViewController {
    
    private enum Constant {
        static let leftSegmentedItem = "Acc"
        static let rightSegmentedItem = "Gyro"
        static let measureButtonTitle = "측정"
        static let stopButtonTitle = "정지"
        static let title = "측정하기"
        static let saveButtonTitle = "저장"
    }
    
    let measureViewModel = MeasureViewModel()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [Constant.leftSegmentedItem,
                                                          Constant.rightSegmentedItem])
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black],
                                                for: UIControl.State.selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black],
                                                for: UIControl.State.normal)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    private let graphView: GraphView = {
        let view = GraphView()
        
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let measureButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Constant.measureButtonTitle, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Constant.stopButtonTitle, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupButtons()
        setupViews()
        bind()
    }
    
    private func bind() {
        measureViewModel.measureDatas.bind { data in
            self.graphView.drawLine(xPoint: data.x.last,
                                    yPoint: data.y.last,
                                    zPoint: data.z.last)
            self.graphView.configure(xPoint: data.x.last,
                                     yPoint: data.y.last,
                                     zPoint: data.z.last)
        }
    }
    
    private func setupNavigation() {
        navigationItem.title = Constant.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constant.saveButtonTitle,
                                                            style: .plain,
                                                            target: self,
                                                            action: nil)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func setupButtons() {
        let measureAction = UIAction { _ in
            self.tappedMeasureButton()
        }
        measureButton.addAction(measureAction, for: .touchUpInside)
        
        let stopAction = UIAction { _ in
            self.tappedStopButton()
        }
        stopButton.addAction(stopAction, for: .touchUpInside)
    }
    
    private func tappedMeasureButton() {
        self.segmentedControl.isUserInteractionEnabled = false
        self.measureButton.isUserInteractionEnabled = false
        self.stopButton.isUserInteractionEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray],
                                                     for: UIControl.State.selected)
        self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray],
                                                     for: UIControl.State.normal)
        self.measureButton.setTitleColor(.gray, for: .normal)
        self.stopButton.setTitleColor(.systemBlue, for: .normal)

        let mode: SensorMode = self.segmentedControl.selectedSegmentIndex == 0 ? .Acc : .Gyro
        self.measureViewModel.startMeasure(mode: mode)
    }
    
    private func tappedStopButton() {
        self.segmentedControl.isUserInteractionEnabled = true
        self.measureButton.isUserInteractionEnabled = true
        self.stopButton.isUserInteractionEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black],
                                                     for: UIControl.State.selected)
        self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black],
                                                     for: UIControl.State.normal)
        self.measureButton.setTitleColor(.systemBlue, for: .normal)
        self.stopButton.setTitleColor(.gray, for: .normal)
        
        let mode: SensorMode = self.segmentedControl.selectedSegmentIndex == 0 ? .Acc : .Gyro
        self.measureViewModel.stopMeasure(mode: mode)
    }
    
    private func setupViews() {
        self.view.backgroundColor = .white
        
        let safeArea = view.safeAreaLayoutGuide
        
        [measureButton, stopButton].forEach(buttonStackView.addArrangedSubview(_:))
        [segmentedControl, graphView, buttonStackView].forEach(view.addSubview(_:))
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            segmentedControl.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.8),
            
            graphView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 30),
            graphView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            graphView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor, multiplier: 1),
            
            buttonStackView.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 30),
            buttonStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor)
        ])
    }
}
