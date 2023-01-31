//
//  MainViewController.swift
//  GyroData
//
//  Created by Baem, Dragon on 2022/09/16.
//

import UIKit

final class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func configureView() {
        let titleView = NavigationTitleView()
        titleView.configureTitleLabel(title: "목록")
        
        view.backgroundColor = .systemBackground
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "측정",
            style: .plain,
            target: self,
            action: #selector(tapRightBarButton)
        )
    }
    
    @objc private func tapRightBarButton() {
        
    }
}
