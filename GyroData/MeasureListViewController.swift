//  GyroData - ViewController.swift
//  Created by zhilly, woong on 2023/01/31

import UIKit

class MeasureListViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(MeasureTableViewCell.self,
                           forCellReuseIdentifier: "MeasureTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
    }
    
    private func setupNavigation() {
        navigationItem.title = "목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정",
                                                            style: .plain,
                                                            target: self,
                                                            action: nil)
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
