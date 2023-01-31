//
//  MeasureViewController.swift
//  GyroData
//
//  Created by stone, LJ on 2023/01/31.
//

import UIKit
import CoreMotion

class MeasureViewController: UIViewController {
    let motionManager = MotionManager()
    
    var motionType: MotionType = .acc
    var coordinates:[(Double, Double, Double)] = []
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Acc", "Gyro"])
        control.selectedSegmentIndex = 0
        control.layer.borderWidth = 1
        control.selectedSegmentTintColor = .systemBlue
        control.translatesAutoresizingMaskIntoConstraints = false
        control.layer.borderColor = UIColor.systemBlue.cgColor
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue],
                                       for: UIControl.State.normal)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white],
                                       for: UIControl.State.selected)
        return control
    }()
    
    var graphView: GraphView = {
        let view = GraphView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let measureButton: UIButton = {
        let button = UIButton()
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureLayout()
        configureAction()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "측정하기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(saveButtonTapped))
    }
    
    func configureAction() {
        self.segmentedControl.addTarget(self,action: #selector(didChangeValue(_:)), for: .valueChanged)
        measureButton.addTarget(self, action: #selector(measureButtonTapped), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
    }
    
    func configureLayout() {
        view.addSubview(segmentedControl)
        view.addSubview(graphView)
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(measureButton)
        buttonStackView.addArrangedSubview(stopButton)
        
        NSLayoutConstraint.activate([
            segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            graphView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 30),
            graphView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),
            graphView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonStackView.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 30),
            buttonStackView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor)
        ])
    }
    
    @objc func saveButtonTapped() { }
    
    @objc func didChangeValue(_ segment: UISegmentedControl) {
        motionType = segment.selectedSegmentIndex == 0 ? .acc : .gyro
    }
    
    @objc func measureButtonTapped() {
        graphView.configureData()
        motionManager.start(type: motionType) { data in
            DispatchQueue.main.async {
                switch self.motionType {
                case .acc:
                    guard let accData = data as? CMAccelerometerData else { return }
                    self.coordinates.append((accData.acceleration.x,
                                             accData.acceleration.y, accData.acceleration.z))
                    self.graphView.drawLine(x: accData.acceleration.x,
                                       y: accData.acceleration.y,
                                       z: accData.acceleration.z)
                case .gyro:
                    guard let gyroData = data as? CMGyroData else { return }
                    self.coordinates.append((gyroData.rotationRate.x,
                                             gyroData.rotationRate.y, gyroData.rotationRate.z))
                    self.graphView.drawLine(x: gyroData.rotationRate.x,
                                            y: gyroData.rotationRate.y,
                                            z: gyroData.rotationRate.z)
                }
            }
        }
    }
    
    @objc func stopButtonTapped() {
        motionManager.stop()
        graphView.reset()
    }
}
