//
//  RecordMotionDataViewController.swift
//  GyroData
//
//  Created by Jiyoung Lee on 2023/01/31.
//

import UIKit

final class RecordMotionDataViewController: UIViewController {
    private let viewModel: RecordMotionDataViewModel

    init(viewModel: RecordMotionDataViewModel) {
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
