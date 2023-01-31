//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

class ViewController: UIViewController {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(rightButtonTapped))
    }
    
    @objc func rightButtonTapped() {
    }
}
