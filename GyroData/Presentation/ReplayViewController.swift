//
//  ReplayViewController.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/26.
//

import UIKit

class ReplayViewController: UIViewController {
    
    var pageType: ReplayViewType?
    
    init(pageType: ReplayViewType) {
        super.init(nibName: nil, bundle: nil)
        self.pageType = pageType
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = ReplayView()
        view.backgroundColor = .white
        
        self.navigationItem.title = "다시보기"
    }
}
