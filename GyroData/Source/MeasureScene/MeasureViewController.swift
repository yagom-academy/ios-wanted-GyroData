//
//  MeasureViewController.swift
//  GyroData
//
//  Created by 이태영 on 2023/02/02.
//

import UIKit

final class MeasureViewController: UIViewController {
    private let measureButton: UIButton = {
        let button = UIButton()
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        return stackView
    }()
    
    private let graphView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Acc", "Gyro"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.selectedSegmentTintColor = .systemBlue
        return segmentControl
    }()
    
    private let graphStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubview()
        configureLayout()
        configureNavigation()
    }
}

// MARK: UI Configuration
extension MeasureViewController {
    private func configureSubview() {
        [measureButton, stopButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        [segmentControl, graphView].forEach {
            graphStackView.addArrangedSubview($0)
        }
        
        [graphStackView, buttonStackView].forEach {
            totalStackView.addArrangedSubview($0)
        }
        
        view.backgroundColor = .systemBackground
        view.addSubview(totalStackView)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            totalStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            totalStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            totalStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15),
            totalStackView.bottomAnchor.constraint(lessThanOrEqualTo: safeArea.bottomAnchor),
            
            graphStackView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.4)
        ])
    }
    
    private func configureNavigation() {
        navigationItem.title = "측정하기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .plain,
            target: self,
            action: nil)
    }
}

