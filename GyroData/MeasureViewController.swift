//
//  MeasureViewController.swift
//  GyroData
//
//  Created by stone, LJ on 2023/01/31.
//

import UIKit
import CoreMotion

class MeasureViewController: UIViewController {
    var motion = CMMotionManager()
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Acc", "Gyro"])
        control.selectedSegmentIndex = 0
        control.layer.borderWidth = 1
        control.layer.borderColor = UIColor.systemBlue.cgColor
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue],
                                       for: UIControl.State.normal)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white],
                                       for: UIControl.State.selected)
        control.selectedSegmentTintColor = .systemBlue
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    var graphView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let measureButton: UIButton = {
        let button = UIButton()
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(MeasureViewController.self,
                         action: #selector(measureButtonTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(MeasureViewController.self,
                         action: #selector(stopButtonTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureView()
        acclerometerMode()
        gyroMode()
    }
    
    func configureView() {
        view.addSubview(segmentedControl)
        view.addSubview(graphView)
        view.addSubview(measureButton)
        view.addSubview(stopButton)
        configureSegmentedControl()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "측정하기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(saveButtonTapped))
    }
    
    @objc func saveButtonTapped() { }
    
    func configureSegmentedControl() {
        self.segmentedControl.addTarget(self,
                                        action: #selector(didChangeValue(_:)),
                                        for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
        self.didChangeValue(self.segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            graphView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            graphView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),
            graphView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            measureButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 30),
            measureButton.leadingAnchor.constraint(equalTo: graphView.leadingAnchor),
            measureButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            stopButton.topAnchor.constraint(equalTo: measureButton.bottomAnchor, constant: 30),
            stopButton.leadingAnchor.constraint(equalTo: graphView.leadingAnchor),
            stopButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3)
        ])
    }
    
    @objc func didChangeValue(_ segment: UISegmentedControl) {  }
    
    @objc func measureButtonTapped() {
        print("측정버튼 터치")
    }
    
    @objc func stopButtonTapped() {
        print("정지버튼 터치")
    }
    
    func acclerometerMode() {
        motion.accelerometerUpdateInterval = 1
        motion.startAccelerometerUpdates(to: OperationQueue.current!) { (data,error) in

        }
    }
    
    func gyroMode() {
        motion.gyroUpdateInterval = 1
        motion.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
           
        }
    }
}
