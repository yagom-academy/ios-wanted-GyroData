//
//  MeasureViewController.swift
//  GyroData
//
//  Created by 정재근 on 2022/12/26.
//

import UIKit

final class MeasureViewController: BaseViewController {
    // MARK: - View
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.tintColor, for: .normal)
        button.addTarget(self, action: #selector(self.didTapSaveButton), for: .touchDown)
        
        return button
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: [Segment.Accelerometer.rawValue, Segment.Gyro.rawValue])
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
        button.addTarget(self, action: #selector(self.didTapMeasureButton), for: .touchDown)
        
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.tintColor, for: .normal)
        button.addTarget(self, action: #selector(self.didTapStopButton), for: .touchDown)
        
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
        print("Measure")
    }
    
    @objc private func didTapStopButton() {
        print("Stop")
    }
}
