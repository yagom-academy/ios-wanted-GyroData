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
        
        dateLabel.text = "2022/12/29"
        titleLabel.text = "Gyro Drop"
        timerLabel.text = "5.0"
    }
    
    private func setupView() {
        addSubViews()
    }
    
    private func addSubViews() {
        entireStackView.addArrangedSubview(playStackView)
        playStackView.addArrangedSubview(playButton)
        playStackView.addArrangedSubview(timerLabel)
    }
}
