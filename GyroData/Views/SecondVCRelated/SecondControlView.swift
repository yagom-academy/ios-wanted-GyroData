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
    
    // MARK: Init
    init() {
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
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
    }
    
    func configureView() {
        stackView.addStyles(style: controlStackViewStyling)
        measureButton.addStyles(style: measureButtonStyling)
        stopButton.addStyles(style: stopButtonStyling)
    }
    
    func bind() {
        
    }
}
