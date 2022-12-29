//
//  MotionResultPlayViewController.swift
//  GyroData
//
//  Created by 이호영 on 2022/12/29.
//

import UIKit

final class MotionResultPlayViewController: MotionResultViewController {
    
    private let playStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let playButton = PlayButton()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        playButton.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setupView() {
        addSubViews()
    }
    
    private func addSubViews() {
        entireStackView.addArrangedSubview(playStackView)
        playStackView.addArrangedSubview(playButton)
        playStackView.addArrangedSubview(timerLabel)
    }
    
    @objc private func playButtonTapped(_ sender: PlayButton) {
        if playButton.isSelected {
            startDrawing()
        } else {
            stopDrawing()
        }
    }
}

// MARK: play Graph

extension MotionResultViewController {
    func startDrawing() {
        guard let motionInformation = viewModel.motionInformation.value else { return }
        // graphView에서 graph 그리기
    }
    
    func stopDrawing() {
        guard let motionInformation = viewModel.motionInformation.value else { return }
        // graphView에서 graph 그리기
    }
}
