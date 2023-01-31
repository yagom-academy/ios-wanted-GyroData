//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setNavigationBar()
    }
    
    func setNavigationBar() {
        let button = UIBarButtonItem(title: "측정", style: .plain, target: self, action: #selector(didTapRecordButton))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func didTapRecordButton() {
        let controller = RecordViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

