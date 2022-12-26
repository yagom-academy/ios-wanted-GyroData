//
//  MainViewController.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/09/16.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        commonInit()
    }
    
    // MARK: - Methods
    
    private func commonInit() {
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "목록"
        
        let rightBarButton = UIBarButtonItem(
            title: "측정",
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTapped)
        )
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc private func rightBarButtonTapped() {
        print("view move")
    }
}
