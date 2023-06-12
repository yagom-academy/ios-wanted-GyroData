//
//  GyroDataListViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

final class GyroDataListViewController: UIViewController {
    
    private let gyroDataTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    private func setUpView() {
        view.backgroundColor = .white
        view.addSubview(gyroDataTableView)
        setUpGyroDataTableView()
    }
    
    private func setUpGyroDataTableView() {
        let safeArea = view.safeAreaLayoutGuide
        gyroDataTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gyroDataTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            gyroDataTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            gyroDataTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            gyroDataTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }


}

