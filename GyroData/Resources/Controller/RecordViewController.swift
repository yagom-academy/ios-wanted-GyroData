//
//  RecordViewController.swift
//  GyroData
//
//  Copyright (c) 2023 Minii All rights reserved.
        

import UIKit

class RecordViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

extension RecordViewController {
    func configureUI() {
        setBackgroundColor()
        setNavigationBar()
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    
    func setNavigationBar() {
        navigationItem.title = "측정"
        
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(didTapSaveButton))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func didTapSaveButton() {
        // TODO: 저장 메서드 생성
    }
}
