//
//  replayViewController.swift
//  GyroData
//
//  Created by 천승희 on 2022/12/29.
//

import UIKit

class ReplayViewTypeViewController: BaseViewController {
    // MARK: - View
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "2022/09/07 15:10:11"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.text = "View"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25)
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeLabel, typeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        
        return stackView
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            stackView
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        
        return stackView
    }()
    // MARK: - Properties
    private let viewTitle: String = "다시보기"
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        constraints()
    }
}

// MARK: - ConfigureUI
extension ReplayViewTypeViewController {
    private func configureUI() {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.title = self.viewTitle
    }
}

// MARK: - Constraint
extension ReplayViewTypeViewController {
    private func constraints() {
        vStackViewConstraints()
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
}
