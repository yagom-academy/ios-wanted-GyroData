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

        view = replayView
        view.backgroundColor = .white
        
        self.navigationItem.title = "다시보기"
    }
}
