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
        
        replayView.measurementTime.text = motionInfo?.data.date
        replayView.pageTypeLabel.text = motionInfo?.pageType.name

        replayView.playButton.addTarget(self, action: #selector(activateTimer), for: .touchUpInside)
        
        if motionInfo?.pageType == ReplayViewPageType.view {
            replayView.playStackView.isHidden = true
        }
        
        view = replayView
        view.backgroundColor = .white
        
        self.navigationItem.title = "다시보기"
    }
    
    @objc
    func activateTimer() {
        Stopwatch.share.isRunning.toggle()

        if Stopwatch.share.isRunning == false {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 45, weight: .light)
            replayView.playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: imageConfig), for: .normal)
            return
        }

        // TODO: 시간 Motion에 추가 후 바꾸기
        Stopwatch.share.activateTimer(for: 6, 1)
    }
}

extension ReplayViewController: SendDataDelegate {
    func sendData<T>(_ data: T) {
        motionInfo = data as? MotionInfo
    }
}
