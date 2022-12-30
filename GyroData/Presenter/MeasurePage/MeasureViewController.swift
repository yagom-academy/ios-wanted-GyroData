//
//  MeasureViewController.swift
//  GyroData
//
//  Created by Tak on 2022/12/28.
//

import UIKit

class MeasureViewController: UIViewController {
    
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
    private let recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("측정", for: .normal)
        return button
    }()
    private let pauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("정지", for: .normal)
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
    
    @objc private func saveRecord(_ sender: Any) {
        // 저장 로직 구현?
        self.navigationController?.popViewController(animated: true)
    }
}

enum SensorType: String, CaseIterable {
    case acceleromter = "Acc"
    case gyro = "Gyro"
}
