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
        label.text = "0.0"
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var timer: Timer?
    private var timerIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        playButton.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setupView() {
        graphView.clearSegmanet()
        addSubViews()
    }
    
    private func addSubViews() {
        entireStackView.addArrangedSubview(playStackView)
        playStackView.addArrangedSubview(playButton)
        playStackView.addArrangedSubview(timerLabel)
        
        timerLabel.widthAnchor.constraint(equalTo: view.widthAnchor,
                                          multiplier: 1/10).isActive = true
    }
    
    @objc private func playButtonTapped(_ sender: PlayButton) {
        if playButton.isSelected {
            startDrawing()
        } else {
            stopDrawing()
        }
    }
    
    override func configureUI(motion: Motion) {
        super.configureUI(motion: motion)
        titleLabel.text = "Play"
    }
    
    override func drawGraph(motion: Motion) {
        graphView.setupSegmentSize(height: view.bounds.width)
    }
}

// MARK: play Graph

extension MotionResultPlayViewController {
    func startDrawing() {
        guard let motion = viewModel.motion.value else { return }
        let xList = motion.xData
        let yList = motion.yData
        let zList = motion.zData
        let timeOut = min(motion.xData.count, motion.yData.count, motion.zData.count)
        var timeCount = Double.zero
        
        if timerIndex == timeOut {
            graphView.clearSegmanet()
            timerIndex = 0
        }
        
        timer = Timer(timeInterval: MotionMeasurementNumber.updateInterval,
                      repeats: true,
                      block: { [self] timer in
            
            if timerIndex == timeOut {
                timer.invalidate()
                self.timer = nil
                playButton.isSelected = false
                return
            }
            
            let motionData = [xList[timerIndex], yList[timerIndex], zList[timerIndex]]
            graphView.add(motionData)
            
            timerIndex += 1
            timeCount += MotionMeasurementNumber.updateInterval
            timerLabel.text = String(format: "%.1f", timeCount)
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
