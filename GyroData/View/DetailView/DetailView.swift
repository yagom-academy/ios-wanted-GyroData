//
//  DetailView.swift
//  GyroData
//
//  Created by minsson on 2022/12/29.
//

import UIKit

final class DetailView: UIView {
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 30
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
        return stack
    }()
    
    private let labelStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        return stack
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    private let graphContainerView: GraphContainerView = {
        let view = GraphContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let playButton: UIButton = {
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
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = "00.0"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubviews()
        setLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailView {
    func setupMode(with viewModel: DetailViewModel) {
        graphContainerView.graphView.retrieveData(data: viewModel.model)
        viewModel.delegate = graphContainerView.graphView
        
        dateLabel.text = viewModel.model.date.translateToString()
        typeLabel.text = viewModel.currenType.rawValue
        if viewModel.currenType == .view {
            playButton.isHidden = true
            timerLabel.isHidden = true
            graphContainerView.graphView.drawMode = .image
        }
    }
}

private extension DetailView {
    func addSubviews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(labelStackView)
        labelStackView.addArrangedSubview(dateLabel)
        labelStackView.addArrangedSubview(typeLabel)
        mainStackView.addArrangedSubview(graphContainerView)
        addSubview(playButton)
        addSubview(timerLabel)
    }
    
    func setLayer() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playButton.topAnchor.constraint(equalTo: graphContainerView.bottomAnchor, constant: 40),
            timerLabel.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: graphContainerView.trailingAnchor),
            
            graphContainerView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
}

