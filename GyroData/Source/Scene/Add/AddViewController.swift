//
//  AddViewController.swift
//  GyroData
//
//  Created by Baem, Dragon on 2023/01/31.
//

import UIKit
import CoreMotion

class AddViewController: UIViewController {
    private let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Acc", "Gyro"])
        segmentControl.backgroundColor = .white
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    private let graphView: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        return view
    }()
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("측정", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    private let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("정지", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 30
        return stackView
    }()
    private let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
        configureButtonAction()
    }
    
    private func configureButtonAction() {
        playButton.addTarget(self, action: #selector(updateGravityData), for: .touchDown)
        stopButton.addTarget(self, action: #selector(stopGravityData), for: .touchDown)
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "측정하기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .plain,
            target: self,
            action: #selector(saveMotionData)
        )
    }
    
    private func setUpMainStackView() {
        mainStackView.addArrangedSubview(segmentControl)
        mainStackView.addArrangedSubview(graphView)
        mainStackView.addArrangedSubview(playButton)
        mainStackView.addArrangedSubview(stopButton)
    }
    
    private func configureLayout() {
        setUpMainStackView()
        
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            segmentControl.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.85),
            
            graphView.widthAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.widthAnchor,
                multiplier: 0.85
            ),
            graphView.heightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.heightAnchor,
                multiplier: 0.4
            ),
            
            playButton.heightAnchor.constraint(equalToConstant: view.frame.size.height * 0.02),
            
            mainStackView.widthAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.widthAnchor ,
                multiplier: 0.85
            ),
            mainStackView.heightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.heightAnchor,
                multiplier: 0.7
            ),
            mainStackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: view.frame.size.width * 0.06
            ),
            mainStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: view.frame.size.height * 0.03
            )
        ])
    }
    
    @objc private func saveMotionData() {
        
    }
    
    @objc private func updateGravityData() {
        print(motionManager.isAccelerometerAvailable)
        
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.gyroUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { data, error in
            if error == nil {
                guard let accelerometerData = data else { return }

                print(accelerometerData.acceleration)
            }
        }
        motionManager.startGyroUpdates(to: .main) { data, error in
            if error == nil {
                guard let gyroData = data else { return }

                print(gyroData)
            }
        }
    }
    
    @objc private func stopGravityData() {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
    }
}
