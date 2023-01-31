//
//  MotionDataDetailViewController.swift
//  GyroData
//
//  Created by Jiyoung Lee on 2023/01/31.
//

import UIKit

final class MotionDataDetailViewController: UIViewController {
    private let viewModel: MotionDataDetailViewModel

    init(viewModel: MotionDataDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
