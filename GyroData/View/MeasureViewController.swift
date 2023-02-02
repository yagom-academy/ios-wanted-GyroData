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
    var coordinates: [Coordinate] = []
    
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
    
    @objc func saveButtonTapped() {
        if coordinates.isEmpty {
//            값이 없으면 데이터가 없다는 알림
//            데이터 저장은 비동기로 처리하고 Activity Indicator를 표시해주세요.
//            저장이 성공하면 Indicator를 닫고, 첫 번째 페이지로 이동합니다.
//            저장이 실패하면 Indicator를 닫고, 페이지를 이동하지않고 실패 이유를 Alert으로 띄웁니다.
            return
        }
        
        // 얘네 둘을 비동기로 처리하고 둘다 완료가 되면 인디케이터를 닫도록 해야함
        // -> DispatchGroup
        let id = UUID()
        CoreDataManager.shared.create(entity: MotionEntity.self) { entity in
            entity.id = id
            entity.date = Date()
            entity.time = motionManager.second.decimalPlace(1)
            entity.measureType = motionType.rawValue
        }
        FileManager.default.save(path: id.uuidString, data: coordinates)
    }
    
    @objc func didChangeValue(_ segment: UISegmentedControl) {
        motionType = segment.selectedSegmentIndex == 0 ? .acc : .gyro
    }
    
    @objc func measureButtonTapped() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        segmentedControl.isEnabled = false
        graphView.configureData()
        
        motionManager.confgiureTimeInterval(interval: 0.1)
        motionManager.start(type: motionType) { data in
            DispatchQueue.main.async {
                self.coordinates.append(data)
                self.graphView.drawLine(x: data.x, y: data.y, z: data.z)
            }
        }
    }
    
    @objc func stopButtonTapped() {
        navigationItem.rightBarButtonItem?.isEnabled = true
        segmentedControl.isEnabled = true
        
        motionManager.stop()
    }
}
