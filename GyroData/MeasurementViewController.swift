//
//  MeasurementViewController.swift
//  GyroData
//
//  Created by Judy on 2022/12/27.
//

import UIKit

class MeasurementViewController: UIViewController {
    private let measurementView = MeasurementView()
    
    override func loadView() {
        view = measurementView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        let saveBarButton = UIBarButtonItem(title: "저장",
                                            style: .done,
                                            target: self,
                                            action: #selector(saveButtonTapped))
        
        let backBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(backButtonTapped))
        
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.rightBarButtonItem = saveBarButton
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.title = "측정하기"
    }
    
    @objc private func saveButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
