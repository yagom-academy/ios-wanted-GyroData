//
//  DetailView.swift
//  GyroData
//
//  Created by Aejong on 2023/02/04.
//

import UIKit

final class DetailView: UIView {
    private let stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let dateLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let pageTypeLabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: nil)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        return label
    }()
    
    private let graphContainer = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private let graphBackgroundView = {
        let background = GraphBackgroundView()
        background.translatesAutoresizingMaskIntoConstraints = false
        
        return background
    }()
    
    private let graphView: GraphView
    
    var playButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .black
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        return button
    }()
    
    var timerLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = "00.0"
        
        return label
    }()
    
    
    init(graph: GraphView) {
        graphView = graph
        graphView.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: .zero)
        
        addSubViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        addSubview(stackView)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(pageTypeLabel)
        stackView.addArrangedSubview(graphContainer)
        graphContainer.addSubview(graphBackgroundView)
        graphContainer.addSubview(graphView)
        addSubview(playButton)
        addSubview(timerLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            stackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            
            graphBackgroundView.topAnchor.constraint(equalTo: graphContainer.topAnchor),
            graphBackgroundView.bottomAnchor.constraint(equalTo: graphContainer.bottomAnchor),
            graphBackgroundView.leadingAnchor.constraint(equalTo: graphContainer.leadingAnchor),
            graphBackgroundView.trailingAnchor.constraint(equalTo: graphContainer.trailingAnchor),
            
            graphView.topAnchor.constraint(equalTo: graphContainer.topAnchor),
            graphView.bottomAnchor.constraint(equalTo: graphContainer.bottomAnchor),
            graphView.leadingAnchor.constraint(equalTo: graphContainer.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: graphContainer.trailingAnchor),
            
            playButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            playButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
        
    }
}

extension DetailView {
    func configureView(_ isViewPage: Bool) {
        playButton.isHidden = isViewPage
        timerLabel.isHidden = isViewPage
    }
}
