//
//  DetailViewController.swift
//  GyroData
//
//  Created by parkhyo on 2023/02/02.
//

import UIKit

final class DetailViewController: UIViewController {
    private let dateLabel = UILabel(textStyle: .body)
    private let typeLabel = UILabel(textStyle: .title1)
    
    private lazy var labelStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [dateLabel, typeLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let graphView: GraphView = {
        let view = GraphView(interval: 0.1, duration: 60)
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
    }
}

extension DetailViewController {
    private func setupView() {
        title = "다시보기"
        [labelStackView, graphView].forEach(view.addSubview(_:))
    }
    
    private func setupConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            labelStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            labelStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            graphView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 30),
            graphView.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: labelStackView.trailingAnchor)
        ])
    }
}
