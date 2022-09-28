//
//  SecondControlView.swift
//  GyroData
//
//  Created by CodeCamper on 2022/09/21.
//

import UIKit

class SecondControlView: UIView, SecondViewStyling {
    
    // MARK: UI
    var stackView = UIStackView()
    var measureButton = UIButton()
    var stopButton = UIButton()
    
    // MARK: Properties
    var viewModel: SecondControlViewModel
    
    // MARK: Init
    init(viewModel: SecondControlViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        initViewHierarchy()
        configureView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Presentable
extension SecondControlView: Presentable {
    func initViewHierarchy() {
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(measureButton)
        stackView.addArrangedSubview(stopButton)
        
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        constraint += [
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 48)
        ]
    }
    
    func configureView() {
        stackView.addStyles(style: controlStackViewStyling)
        measureButton.addStyles(style: measureButtonStyling)
        stopButton.addStyles(style: stopButtonStyling)
        measureButton.addTarget(self, action: #selector(didTapMeasureButton), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(didTapStopButton), for: .touchUpInside)
    }
    
    func bind() {
        viewModel.isMeasuringSource = { [weak self] isMeasuring in
            self?.measureButton.isEnabled = !isMeasuring
            self?.stopButton.isEnabled = isMeasuring
        }
    }
    
    // MARK: Actions
    @objc private func didTapMeasureButton() {
        viewModel.didTapMeasureButton()
    }
    
    @objc private func didTapStopButton() {
        viewModel.didTapStopButton()
    }
}
