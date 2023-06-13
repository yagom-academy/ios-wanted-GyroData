//
//  RecordGyroViewController.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import UIKit

final class RecordGyroViewController: UIViewController {
    private lazy var stackView = {
        let stackView = UIStackView(arrangedSubviews: [segmentedControl, recordButton, stopButton])
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 28
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        return stackView
    }()
    private let segmentedControl = GyroSegmentedControl(items: ["Acc", "Gyro"])
    private let recordButton = UIButton()
    private let stopButton = UIButton()
    
    private let viewModel = RecordGyroViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        layout()
        setupSegmentedControl()
        setupRecordButton()
        setupStopButton()
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
            stackView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -32),
            
            segmentedControl.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
    
    private func setupSegmentedControl() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlTapped), for: .valueChanged)
    }
    
    @objc private func segmentedControlTapped(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
    
    private func setupRecordButton() {
        let title = "측정"
        recordButton.setTitle(title, for: .normal)
        recordButton.setTitleColor(.tintColor, for: .normal)
        recordButton.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        
        recordButton.addTarget(self, action: #selector(startRecord), for: .touchUpInside)
    }
    
    private func setupStopButton() {
        let title = "정지"
        stopButton.setTitle(title, for: .normal)
        stopButton.setTitleColor(.tintColor, for: .normal)
        stopButton.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        
        stopButton.addTarget(self, action: #selector(stopRecord), for: .touchUpInside)
    }
    
    @objc private func startRecord() {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        
        viewModel.startRecord(dataTypeRawValue: selectedIndex)
    }
    
    @objc private func stopRecord() {
        viewModel.stopRecord()
    }
}
