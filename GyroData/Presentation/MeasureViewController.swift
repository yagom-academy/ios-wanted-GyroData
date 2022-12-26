//
//  MeasureViewController.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/26.
//

import UIKit

class MeasureViewController: UIViewController {

    let measureView = MeasureView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = measureView
        view.backgroundColor = .white
        
        self.navigationItem.title = "측정하기"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .done,
            target: nil,
            action: nil)
    }
}
