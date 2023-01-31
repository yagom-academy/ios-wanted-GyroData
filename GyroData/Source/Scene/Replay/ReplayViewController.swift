//
//  ReplayViewController.swift
//  GyroData
//
//  Created by Baem, Dragon on 2023/01/31.
//

import UIKit

class ReplayViewController: UIViewController {
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.text = Date().description //삭제
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "View" //삭제
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()
    private let graphView: UIView = {
        let view = UIView()
        view.backgroundColor = .brown // 삭제
        return view
    }()
    private let playToggleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        return button
    }()
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "0.00"
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    private let titleStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .leading
        stackview.distribution = .equalSpacing
        stackview.spacing = 10
        return stackview
    }()
    private let topStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .leading
        stackview.distribution = .equalSpacing
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.spacing = 20
        return stackview
    }()
    private let bottomStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.distribution = .equalSpacing
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        view.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        navigationItem.title = "다시보기"
    }
    
    private func setupTitleStackView() {
        titleStackView.addArrangedSubview(dateLabel)
        titleStackView.addArrangedSubview(titleLabel)
    }
    
    private func setupTopStackView() {
        topStackView.addArrangedSubview(titleStackView)
        topStackView.addArrangedSubview(graphView)
        setupTitleStackView()
    }
    
    private func setupBottomStakcView() {
        bottomStackView.addArrangedSubview(playToggleButton)
        bottomStackView.addArrangedSubview(timerLabel)
    }
    
    private func configureLayout() {
        let margin = view.layoutMarginsGuide
        
        setupTopStackView()
        setupBottomStakcView()
        
        view.addSubview(topStackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            graphView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            graphView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,multiplier: 0.4),
            
            topStackView.topAnchor.constraint(equalTo: margin.topAnchor),
            topStackView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            
            playToggleButton.heightAnchor.constraint(equalToConstant: margin.layoutFrame.size.width * 0.1),
            playToggleButton.widthAnchor.constraint(equalTo: playToggleButton.heightAnchor),
            
            bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 20),
            bottomStackView.leadingAnchor.constraint(
                equalTo: topStackView.leadingAnchor,
                constant: margin.layoutFrame.size.width * 0.4
            ),
            bottomStackView.trailingAnchor.constraint(equalTo: graphView.trailingAnchor)
        ])
    }
}
