//
//  SecondControlView.swift
//  GyroData
//
//  Created by CodeCamper on 2022/09/21.
//

import UIKit

class SecondControlView: UIView, SecondViewStyling {
    
    //output
    var populateAdd = { }
    var populateRemove = { }
    
    // MARK: UI
    var stackView = UIStackView()
    var measureButton = UIButton()
    var stopButton = UIButton()
    
    var testAddButton = UIButton()
    var testRemoveButton = UIButton()
    
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
        
        stackView.addArrangedSubview(testAddButton)
        stackView.addArrangedSubview(testRemoveButton)
        
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
        
        testAddButton.addStyles(style: testAddButtonStyling)
        testRemoveButton.addStyles(style: testRemoveButtonStyling)
    }
    
    func bind() {
        testAddButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        testRemoveButton.addTarget(self, action: #selector(remove), for: .touchUpInside)
    }
    
    @objc func add() {
        populateAdd()
    }
    
    @objc func remove() {
        populateRemove()
    }
}
