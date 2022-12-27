//
//  MeasurementView.swift
//  GyroData
//
//  Created by Judy on 2022/12/27.
//

import UIKit

class MeasurementView: UIView {
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Acc", "Gyro"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let graphView: GraphView = {
        let graph = GraphView()
        graph.translatesAutoresizingMaskIntoConstraints = false
        return graph
    }()
    
    private let measurementButton: UIButton = {
        let button = UIButton()
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubViews()
        setupConstraints()
        self.backgroundColor = .systemBackground
    }
    
    private func addSubViews() {
        entireStackView.addArrangedSubview(segmentedControl)
        entireStackView.addArrangedSubview(graphView)
        entireStackView.addArrangedSubview(measurementButton)
        entireStackView.addArrangedSubview(stopButton)
        
        self.addSubview(entireStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            entireStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                                 constant: 16),
            entireStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                 constant: 16),
            entireStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -16),
            
            graphView.heightAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
}
