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
    
    var timer: Timer?
    
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

extension MotionResultPlayViewController {
    func startDrawing() {
        guard let motionInformation = viewModel.motionInformation.value else { return }
        let xList = motionInformation.xData
        let yList = motionInformation.yData
        let zList = motionInformation.zData
        let timeOut = min(motionInformation.xData.count, motionInformation.yData.count, motionInformation.zData.count)
        var index = 0
        
        timer = Timer(timeInterval: MotionMeasurementNumber.updateInterval, repeats: true, block: { timer in
            if index == timeOut {
                timer.invalidate()
                return
            }
            
            let motionData = [xList[index], yList[index], zList[index]]
            self.graphView.add(motionData)
            
            index += 1
        })

        if let timer = timer {
            RunLoop.current.add(timer, forMode: .default)
        }
    }

    func stopDrawing() {
        guard let currentTimer = timer else { return }
        currentTimer.invalidate()
    }
}
