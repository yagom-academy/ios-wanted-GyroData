//
//  GraphRecordView.swift
//  GyroData
//
//  Created by 이예은 on 2022/12/28.
//

import UIKit
import SwiftUI

class GraphRecordView: UIView {
    private lazy var verticalStackView: UIStackView = {
       var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var dateLabel: UILabel = {
       var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2022/10/20 15:10:11"
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white
        return label
    }()
    
    private lazy var viewNameLabel: UILabel = {
       var label = UILabel()
        label.text = "Play"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private lazy var graphView: UIView = {
        return setupHostView()
    }()
    
    private func setupHostView() -> UIView {
        let host = UIHostingController(rootView: GraphView())
        guard let chartView = host.view else {
            return UIView(frame: .zero)
        }
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.backgroundColor = UIColor(r: 16, g: 17, b: 21, a: 1)
        return chartView
    }
    
    private lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        let image = UIImage(systemName: "play.fill", withConfiguration: imageConfig)
        
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.tintColor = UIColor(r: 101, g: 159, b: 247,a: 1)
        button.backgroundColor = UIColor(r: 30, g: 40, b: 46, a: 1)
        return button
    }()
    
    private lazy var timerLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00.0"
        label.contentCompressionResistancePriority(for: .horizontal)
        label.textColor = .white
        label.font = label.font.withSize(25)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubviews(verticalStackView, graphView, pausePlayButton, timerLabel)
        
        [dateLabel, viewNameLabel].forEach {
            verticalStackView.addArrangedSubview($0)
        }
    }
    
    func setupUI() {
        self.backgroundColor = .white
        graphView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            // MARK: - verticalStackView
            verticalStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            verticalStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            verticalStackView.bottomAnchor.constraint(equalTo: graphView.topAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            // MARK: - graphView
            graphView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            graphView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 80),
            graphView.widthAnchor.constraint(equalToConstant: 300),
            graphView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            // MARK: - pausePlayButton
            pausePlayButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 35),
            pausePlayButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pausePlayButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            // MARK: - timerLabel
            timerLabel.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 35),
            timerLabel.widthAnchor.constraint(equalToConstant: 30),
            timerLabel.leadingAnchor.constraint(equalTo: pausePlayButton.trailingAnchor, constant: 80),
            timerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
}

