//
//  ThirdInfoView.swift
//  GyroData
//
//  Created by 한경수 on 2022/09/21.
//

import UIKit

class ThirdInfoView: UIView, ThirdViewStyling {
    // MARK: UI
    var dateLabel = UILabel()
    var typeLabel = UILabel()
    
    // MARK: Properties
    var viewModel: ThirdInfoViewModel
    
    // MARK: Init
    init(viewModel: ThirdInfoViewModel) {
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
extension ThirdInfoView: Presentable {
    func initViewHierarchy() {
        self.addSubview(dateLabel)
        self.addSubview(typeLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraints) }
        
        constraints += [
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
        ]
        constraints += [
            typeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 6),
            typeLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            typeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
    }
    
    func configureView() {
        dateLabel.addStyles(style: dateLabelStyling)
        typeLabel.addStyles(style: typeLabelStyling)
        
        dateLabel.text = Date().asString()
    }
    
    func bind() {
        viewModel.viewTypeSource = { [weak self] type in
            switch type {
            case .view:
                self?.typeLabel.text = "View"
            case .play:
                self?.typeLabel.text = "Play"
            }
        }
        
        viewModel.dateSource = { [weak self] date in
            self?.dateLabel.text = date
        }
    }
}
