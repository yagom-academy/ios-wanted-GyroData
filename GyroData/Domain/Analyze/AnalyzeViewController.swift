//
//  AnalyzeViewController.swift
//  GyroData
//
//  Created by unchain, Ellen J, yeton on 2022/12/28.
//

import UIKit

final class AnalyzeViewController: UIViewController {
    private let analyzeView = AnalyzeView()
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text = "측정하기"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private lazy var analyzeButton: UIBarButtonItem = {
       let button = UIBarButtonItem()
        button.title = "저장"
        button.tintColor = UIColor(r: 101, g: 159, b: 247, a: 1)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = analyzeView
        self.navigationItem.titleView = titleLabel
        self.navigationItem.rightBarButtonItem = analyzeButton
    }
}
