//
//  ThirdControlView.swift
//  GyroData
//
//  Created by CodeCamper on 2022/09/22.
//

import UIKit

class ThirdControlView: UIView, ThirdViewStyling {
    // MARK: UI
    var controlButton = UIButton()
    var timerLabel = UILabel()
    
    // MARK: Properties
    var viewModel: ThirdControlViewModel
    
    // MARK: Init
    init(viewModel: ThirdControlViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        initViewHierarchy()
        configureView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Presentable
extension ThirdControlView: Presentable {
    func initViewHierarchy() {
        self.addSubview(controlButton)
        self.addSubview(timerLabel)
        
        controlButton.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        constraint += [
            controlButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 48),
            controlButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            controlButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            controlButton.widthAnchor.constraint(equalToConstant: 42),
            controlButton.heightAnchor.constraint(equalToConstant: 42),
            timerLabel.centerYAnchor.constraint(equalTo: controlButton.centerYAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ]
    }
    
    func configureView() {
        controlButton.addStyles(style: controlButtonStyling)
        controlButton.addTarget(self, action: #selector(didTapControlButton), for: .touchUpInside)
        timerLabel.addStyles(style: timerLabelStying)
    }
    
    func bind() {
        viewModel.isPlayingChanged = { [weak self] isPlaying in
            if isPlaying {
                self?.controlButton.configuration?.image = UIImage(named: "icon_stop")
            } else {
                self?.controlButton.configuration?.image = UIImage(named: "icon_play")
            }
        }
        
        viewModel.currentTimeChanged = { [weak self] currentTime in
            let currentTime = round(currentTime*100) / 100
            self?.timerLabel.text = "\(currentTime)"
        }
    }
    
    // MARK: Actions
    @objc private func didTapControlButton() {
        viewModel.didTapControlButton()
    }
}
