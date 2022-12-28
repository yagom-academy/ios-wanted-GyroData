//
//  MotionResultViewController.swift
//  GyroData
//
//  Created by 이호영 on 2022/12/28.
//

import UIKit

class MotionResultViewController: UIViewController {

    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let graphView: GraphView = {
        let graph = GraphView()
        graph.translatesAutoresizingMaskIntoConstraints = false
        return graph
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureNavigationBar()
    }
    
    private func setupView() {
        addSubViews()
        setupConstraints()
        view.backgroundColor = .systemBackground
    }
    
    private func addSubViews() {
        entireStackView.addArrangedSubview(informationStackView)
        entireStackView.addArrangedSubview(graphView)
        
        informationStackView.addArrangedSubview(dateLabel)
        informationStackView.addArrangedSubview(titleLabel)
        
        view.addSubview(entireStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            entireStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: 16),
            entireStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                 constant: 16),
            entireStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -16),
            
            graphView.heightAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "다시보기"
    }

}
