//
//  ReplayViewController.swift
//  GyroData
//
//  Created by seohyeon park on 2022/12/26.
//

import UIKit

class ReplayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = ReplayView()
        view.backgroundColor = .white
        
        self.navigationItem.title = "다시보기"
    }
}
