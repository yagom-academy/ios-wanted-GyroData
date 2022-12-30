//
//  ReplayViewController.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/26.
//

import UIKit

class ReplayViewController: UIViewController {
    
    private var motionInfo: MotionInfo?
    private let replayView = ReplayView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupDefault()
    }
    
    private func setupNavigationItem() {
        self.navigationItem.title = "다시보기"
    }
    
    private func setupDefault() {
        replayView.measurementTime.text = motionInfo?.data.date
        replayView.pageTypeLabel.text = motionInfo?.pageType.name

        replayView.playButton.addTarget(self, action: #selector(activateTimer), for: .touchUpInside)
        
        if motionInfo?.pageType == ReplayViewPageType.view {
            replayView.playStackView.isHidden = true
        }
        
        view = replayView
        view.backgroundColor = .white
    }
    
    @objc
    func activateTimer() {
        Stopwatch.share.isRunning.toggle()
        
        let systemImageName = Stopwatch.share.isRunning ? "play.fill" : "stop.fill"
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 45,
            weight: .light
        )
        replayView.playButton.setImage(
            UIImage(
                systemName: systemImageName,
                withConfiguration: imageConfig),
            for: .normal
        )

        // TODO: 시간 Motion에 추가 후 바꾸기
        Stopwatch.share.activateTimer(for: 6, 1)
        guard let motion = motionInfo?.data else { return }
        replayView.chartsView.playChart(value: motion)
    }
}

extension ReplayViewController: SendDataDelegate {
    func sendData<T>(_ data: T) {
        motionInfo = data as? MotionInfo
    }
}
