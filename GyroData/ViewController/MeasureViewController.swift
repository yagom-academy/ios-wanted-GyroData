//
//  MeasureViewController.swift
//  GyroData
//
//  Created by 정재근 on 2022/12/26.
//

import UIKit
import CoreMotion

final class MeasureViewController: BaseViewController {
    // MARK: - View
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.tintColor, for: .normal)
        button.addTarget(self, action: #selector(self.didTapSaveButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: [SensorType.accelerometer.rawValue, SensorType.gyro.rawValue])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = .white
        segmentControl.selectedSegmentTintColor = .systemBlue
        segmentControl.layer.borderWidth = 1
        segmentControl.layer.borderColor = UIColor.black.cgColor
        
        return segmentControl
    }()
    
    private lazy var graphView: GraphView = {
        let view = GraphView()
        
        return view
    }()
    
    private lazy var measureButton: UIButton = {
        let button = UIButton()
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.tintColor, for: .normal)
        button.addTarget(self, action: #selector(self.didTapMeasureButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.tintColor, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(self.didTapStopButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            segmentControl, graphView, measureButton, stopButton
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        
        return stackView
    }()
    // MARK: - Properties
    private let viewTitle: String = "측정하기"
    private var motionManager = CMMotionManager()
    private var accTimer: Timer?
    private var gyroTimer: Timer?
    private var timeLeft: Double = 60
    private var isMeasured: Bool = false {
        didSet {
            if isMeasured {
                self.stopButton.isEnabled = true
                self.segmentControl.isEnabled = false
                self.measureButton.isEnabled = false
                self.saveButton.isEnabled = false
            } else {
                self.saveButton.isEnabled = true
                self.segmentControl.isEnabled = true
                self.measureButton.isEnabled = true
                self.stopButton.isEnabled = false
            }
        }
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        constraints()
    }
}
// MARK: - ConfigureUI
extension MeasureViewController {
    private func configureUI() {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.title = self.viewTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }
}

// MARK: - Constraint
extension MeasureViewController {
    private func constraints() {
        vStackViewConstraints()
        segmentControlConstraints()
        graphViewConstraints()
        
    }
    
    private func vStackViewConstraints() {
        self.view.addSubview(vStackView)
        self.vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = [
            self.vStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.vStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.vStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(layout)
    }
    
    private func segmentControlConstraints() {
        self.segmentControl.translatesAutoresizingMaskIntoConstraints = false

        let layout = [
            self.segmentControl.widthAnchor.constraint(equalTo: vStackView.widthAnchor)
        ]

        NSLayoutConstraint.activate(layout)
    }

    private func graphViewConstraints() {
        self.graphView.translatesAutoresizingMaskIntoConstraints = false

        let layout = [
            self.graphView.widthAnchor.constraint(equalTo: self.vStackView.widthAnchor),
            self.graphView.heightAnchor.constraint(equalTo: self.vStackView.widthAnchor)
        ]

        NSLayoutConstraint.activate(layout)
    }
}
// MARK: - Action
extension MeasureViewController {
    @objc private func didTapSaveButton() {
        print("Save")
    }
    
    @objc private func didTapMeasureButton() {
        print(#function)
        switch self.segmentControl.selectedSegmentIndex {
        case SensorType.accelerometer.index :
            startAccMeasure()
        case SensorType.gyro.index :
            startGyroMeasure()
        default:
            break
        }
        self.isMeasured = true
    }
    
    @objc private func didTapStopButton() {
        switch self.segmentControl.selectedSegmentIndex {
        case SensorType.accelerometer.index :
            accTimer?.invalidate()
        case SensorType.gyro.index :
            gyroTimer?.invalidate()
        default:
            break
        }
        self.isMeasured = false
        print(#function)
    }
    
    private func startAccMeasure() {
        self.graphView.clear()
        var max = SensorType.accelerometer.max
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates()
            self.graphView.setMax(max: max)
            self.accTimer = Timer(fire: Date(), interval: 0.1, repeats: true, block: { timer in
                if self.timeLeft > 0 {
                    if let accData = self.motionManager.accelerometerData {
                        let x = accData.acceleration.x
                        let y = accData.acceleration.y
                        let z = accData.acceleration.z

                        self.graphView.setLabel(x: x, y: y, z: z)
                        self.graphView.getData(x: x, y: y, z: z)
                        
                        let regularExpression = abs(x) > max || abs(y) > max || abs(z) > max
                        
                        if regularExpression {
                            self.graphView.isOverflowValue = true
                            max *= 1.2
                            self.graphView.setMax(max: max)
                        }
                        
                        self.graphView.setNeedsDisplay()
                        self.timeLeft -= 0.1
                    }
                } else {
                    self.accTimer?.invalidate()
                }
            })
            if let timer = self.accTimer {
                RunLoop.current.add(timer, forMode: .default)
            }
        }
    }
    
    private func startGyroMeasure() {
        self.graphView.clear()
        var max = SensorType.gyro.max
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.1
            motionManager.startGyroUpdates()
            self.graphView.setMax(max: max)
            self.gyroTimer = Timer(fire: Date(), interval: 0.1, repeats: true, block: { timer in
                if self.timeLeft > 0 {
                    if let gyroData = self.motionManager.gyroData {
                        let x = gyroData.rotationRate.x
                        let y = gyroData.rotationRate.y
                        let z = gyroData.rotationRate.z

                        self.graphView.setLabel(x: x, y: y, z: z)
                        self.graphView.getData(x: x, y: y, z: z)
                        
                        let regularExpression = abs(x) > max || abs(y) > max || abs(z) > max
                        
                        if regularExpression {
                            self.graphView.isOverflowValue = true
                            max *= 1.2
                            self.graphView.setMax(max: max)
                        }
                        
                        self.graphView.setNeedsDisplay()
                        self.timeLeft -= 0.1
                    }
                } else {
                    self.gyroTimer?.invalidate()
                }
            })
            if let timer = self.gyroTimer {
                RunLoop.current.add(timer, forMode: .default)
            }
        }
    }
    
    private func initDate() {
        timeLeft = 60
        
    }
}
