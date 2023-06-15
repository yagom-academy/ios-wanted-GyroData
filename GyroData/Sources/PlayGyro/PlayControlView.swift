//
//  PlayControlView.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/15.
//

import UIKit

final class PlayControlView: UIView {
    private let playImage = {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 60)
        let image = UIImage(systemName: "play.fill", withConfiguration: imageConfiguration)
        
        return image
    }()
    private let stopImage = {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 60)
        let image = UIImage(systemName: "stop.fill", withConfiguration: imageConfiguration)
        
        return image
    }()
    private var buttonImage: UIImage? {
        if isPlaying {
            return stopImage
        }
        
        return playImage
    }
    @Published var isPlaying = false
    
    private lazy var playOrStopButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(playImage, for: .normal)
        button.tintColor = .label
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return button
    }()
    
    private let durationLabel = {
        let label = UILabel()
        
        label.text = "00.0"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        layout()
        addButtonAction()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(playOrStopButton)
        addSubview(durationLabel)
    }
    
    private func layout() {
        let safe = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            playOrStopButton.topAnchor.constraint(equalTo: safe.topAnchor),
            playOrStopButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            playOrStopButton.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            
            durationLabel.topAnchor.constraint(equalTo: safe.topAnchor),
            durationLabel.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            durationLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor)
        ])
    }
    
    private func addButtonAction() {
        playOrStopButton.addTarget(self, action: #selector(touchUpPlayOrStop), for: .touchUpInside)
    }
    
    @objc private func touchUpPlayOrStop() {
        isPlaying.toggle()
        playOrStopButton.setImage(buttonImage, for: .normal)
    }
    
    func configureLabel(duration: Double) {
        durationLabel.text = String(format: "%00.1f", duration)
    }
}
