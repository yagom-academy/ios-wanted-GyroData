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
        let segmentControl = UISegmentedControl(items: [SensorType.acc.segmentTitle, SensorType.gyro.segmentTitle])
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
    
    private lazy var indicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = .black
        
        return activityIndicator
    }()
    // MARK: - Properties
    private let viewTitle: String = "측정하기"
    private var motionManager = CMMotionManager()
    private var accTimer: Timer?
    private var gyroTimer: Timer?
    // MARK: - MeasureData
    private var measureDate: String = ""
    private var runningTime: Int = 0
    private var sensorType: String = ""
    private var xData: [Double] = []
    private var yData: [Double] = []
    private var zData: [Double] = []
    
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
        indicatorConstraints()
    }
    
    private func vStackViewConstraints() {
        self.view.addSubview(self.vStackView)
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
    
    private func indicatorConstraints() {
        self.view.addSubview(self.indicator)
        
        self.indicator.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = [
            self.indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(layout)
    }
}
// MARK: - ButtonAction
extension MeasureViewController {
    @objc private func didTapSaveButton() {
        saveMeasureData()
    }
    
    @objc private func didTapMeasureButton() {
        print(#function)
        switch self.segmentControl.selectedSegmentIndex {
        case SensorType.acc.index :
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
        case SensorType.acc.index :
            accTimer?.invalidate()
        case SensorType.gyro.index :
            gyroTimer?.invalidate()
        default:
            break
        }
        self.isMeasured = false
    }
}
// MARK: - MeasureFunction
extension MeasureViewController {
    private func startAccMeasure() {
        self.initData(sensorType: .acc)
        var max = SensorType.acc.max
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates()
            self.graphView.setMax(max: max)
            self.accTimer = Timer(fire: Date(), interval: 0.1, repeats: true, block: { timer in
                if self.runningTime < 600 {
                    if let accData = self.motionManager.accelerometerData {
                        let x = accData.acceleration.x
                        let y = accData.acceleration.y
                        let z = accData.acceleration.z
                        
                        self.xData.append(x)
                        self.yData.append(y)
                        self.zData.append(z)

                        self.graphView.setLabel(x: x, y: y, z: z)
                        self.graphView.getData(x: x, y: y, z: z)
                        
                        let regularExpression = abs(x) > max || abs(y) > max || abs(z) > max
                        
                        if regularExpression {
                            self.graphView.isOverflowValue = true
                            max += self.maxValue(x: x, y: y, z: z) * 0.2
                            self.graphView.setMax(max: max)
                        }
                        
                        self.graphView.setNeedsDisplay()
                        self.runningTime += 1
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
        self.initData(sensorType: .gyro)
        var max = SensorType.gyro.max
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.1
            motionManager.startGyroUpdates()
            self.graphView.setMax(max: max)
            self.gyroTimer = Timer(fire: Date(), interval: 0.1, repeats: true, block: { timer in
                if self.runningTime < 600 {
                    if let gyroData = self.motionManager.gyroData {
                        let x = gyroData.rotationRate.x
                        let y = gyroData.rotationRate.y
                        let z = gyroData.rotationRate.z
                        
                        self.xData.append(x)
                        self.yData.append(y)
                        self.zData.append(z)

                        self.graphView.setLabel(x: x, y: y, z: z)
                        self.graphView.getData(x: x, y: y, z: z)
                        
                        let regularExpression = abs(x) > max || abs(y) > max || abs(z) > max
                        
                        if regularExpression {
                            self.graphView.isOverflowValue = true
                            max += self.maxValue(x: x, y: y, z: z) * 0.2
                            self.graphView.setMax(max: max)
                        }
                        
                        self.graphView.setNeedsDisplay()
                        self.runningTime += 1
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
    
    private func saveMeasureData() {
        self.indicator.startAnimating()
        
        if runningTime == 0 {
            let alert = AlertManager.alert(title: "값을 측정후 저장해주세요.", alertType: .saveFail)
            present(alert, animated: true, completion: nil)
            self.indicator.stopAnimating()
            
            return
        }
        
        let dispatchGroup = DispatchGroup()
        
        let _ = measureDataForCoreData(runningTime: self.runningTime,
                                                 date: self.measureDate,
                                                 sensor: self.sensorType,
                                                 x: self.xData,
                                                 y: self.yData,
                                                 z: self.zData)
        
        let measureValue = MeasureValue(measureDate: self.measureDate,
                                        sensorType: self.sensorType,
                                        measureTime: String(Double(self.runningTime) / 10),
                                        xData: self.xData,
                                        yData: self.yData,
                                        zData: self.zData)
        
        DispatchQueue.global().async(group: dispatchGroup) {
            CoreDataManager.shared.saveContext()
        }
        
        DispatchQueue.global().async(group: dispatchGroup) {
            do {
                try FileManagerService.shared.saveMeasureFile(data: measureValue)
            } catch {
                DispatchQueue.main.async {
                    let alert = AlertManager.alert(title: error.localizedDescription, alertType: .saveFail)
                    self.present(alert, animated: true)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            let alert = AlertManager.alert(title: "저장 완료", alertType: .saveSuccess(self!))
            self?.present(alert, animated: true, completion: nil)
            self?.indicator.stopAnimating()
        }
    }
    
    private func initData(sensorType: SensorType) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-M-d_HH:mm:ss"
        self.graphView.clear()
        self.graphView.setMax(max: sensorType.max)
        
        self.runningTime = 0
        self.xData.removeAll()
        self.yData.removeAll()
        self.zData.removeAll()
        self.sensorType = sensorType.rawValue
        self.measureDate = formatter.string(from: date)
    }
    
    private func isEnableSaveCheck(runningTime: Int) {
        
    }
    
    private func measureDataForCoreData(runningTime: Int, date: String, sensor: String, x: [Double], y: [Double], z: [Double]) -> MeasureData {
        let measureData = MeasureData(context: CoreDataManager.shared.context)
        measureData.measureTime = String(Double(runningTime) / 10)
        measureData.measureDate = date
        measureData.sensorType = sensor
        measureData.xData = x
        measureData.yData = y
        measureData.zData = z
        
        return measureData
    }
    
    private func maxValue(x: Double, y: Double, z: Double) -> Double {
        let arr = [x,y,z]
        return arr.max()!
    }
}
