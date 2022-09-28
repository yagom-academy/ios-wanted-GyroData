//
//  SecondHoveringIndicatorView.swift
//  GyroData
//
//  Created by CodeCamper on 2022/09/26.
//

import UIKit

class SecondHoveringIndicatorView: UIView, SecondViewStyling {
    // MARK: UI
    var activityIndicator = UIActivityIndicatorView()
    
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
extension SecondHoveringIndicatorView: Presentable {
    func initViewHierarchy() {
        self.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        constraint += [
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ]
    }
    
    func configureView() {
        self.backgroundColor = .white.withAlphaComponent(0.8)
        activityIndicator.startAnimating()
    }
    
    func bind() {
        
    }
}
