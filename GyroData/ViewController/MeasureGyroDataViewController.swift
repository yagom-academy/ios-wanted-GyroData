//
//  MeasureGyroDataViewController.swift
//  GyroData
//
//  Created by 리지 on 2023/06/13.
//

import UIKit

final class MeasureGyroDataViewController: UIViewController {
    
    private var selectedSensor: SensorType = .accelerometer
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Acc", "Gyro"])
        
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    private func setUpView() {
        setUpNavigationBar()
        
        view.backgroundColor = .white
        view.addSubview(segmentedControl)
        setUpSegmentedControl()
    }
    
    private func setUpNavigationBar() {
        let title = "측정하기"
        let save = "저장"
        let rightButtonItem = UIBarButtonItem(title: save,
                                              style: .plain,
                                              target: self,
                                              action: #selector(saveButtonTapped))
        navigationItem.title = title
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    @objc private func saveButtonTapped() {
        print("저장버튼이 눌렸습니다.")
    }
    
    private func setUpSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .systemTeal
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.darkGray
            ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.white
            ]
        
        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        segmentedControl.addTarget(self, action: #selector(changeSensorType), for: .valueChanged)
        
        let safeArea = view.safeAreaLayoutGuide
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            segmentedControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30)
        ])
    }
    
    @objc private func changeSensorType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedSensor = .accelerometer
        case 1:
            selectedSensor = .gyroscope
        default:
            return
        }
    }
}
