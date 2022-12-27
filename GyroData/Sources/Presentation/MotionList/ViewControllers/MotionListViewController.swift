//
//  MotionListViewController.swift
//  GyroData
//
//  Created by Ari on 2022/12/27.
//

import UIKit

class MotionListViewController: UIViewController {

    weak var coordinator: MotionListCoordinatorInterface?
        
    private let viewModel: MotionListViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        
    }

    init(viewModel: MotionListViewModel, coordinator: MotionListCoordinatorInterface) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = "목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "측정",
            style: .plain,
            target: self,
            action: #selector(didTapMeasure(_:))
        )
    }
    
    @objc private func didTapMeasure(_ sender: UIBarButtonItem) {
        coordinator?.showMotionMeasureView()
    }
}
