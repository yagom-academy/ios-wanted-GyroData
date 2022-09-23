//
//  PlayGyroViewController.swift
//  GyroData
//
//  Created by 신동오 on 2022/09/22.
//

import UIKit

class PlayGraphViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "다시보기"
        self.view.backgroundColor = .white
        print(motionInfo)
    }

    var motionInfo : MotionInfo?
    
    func setMotionInfo(_ motionInfo:MotionInfo){
        self.motionInfo = motionInfo
    }
}
