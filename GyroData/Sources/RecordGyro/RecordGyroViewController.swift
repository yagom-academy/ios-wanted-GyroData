//
//  RecordGyroViewController.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import UIKit

final class RecordGyroViewController: UIViewController {
    private let gyroRecorder = GyroRecorder.shared
    
    private lazy var segmentedControl = GyroSegmentedControl(items: ["Acc", "Gyro"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        layout()
        setupSegmentedControl()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(segmentedControl)
    }
    
    private func layout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: safe.topAnchor, constant: 12),
            segmentedControl.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 32),
            segmentedControl.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -32),
            segmentedControl.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(segmentedControlTapped), for: .valueChanged)
    }
    
    @objc private func segmentedControlTapped(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
}
