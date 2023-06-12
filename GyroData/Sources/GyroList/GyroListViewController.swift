//
//  GyroListViewController.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import UIKit

final class GyroListViewController: UIViewController {
    enum Section {
        case main
    }
    
    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Section, GyroData>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationItems()
        setupTableView()
        layout()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationItems() {
        let title = "목록"
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        navigationItem.titleView = titleLabel
        
        let rightBarButtonTitle = "측정"
        let rightBarButton = UIBarButtonItem(title: rightBarButtonTitle,
                                             image: nil,
                                             target: self,
                                             action: #selector(recordGyro))
        rightBarButton.setTitleTextAttributes([.font: UIFont.preferredFont(forTextStyle: .title2)], for: .normal)
        navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    @objc private func recordGyro() {        
        let recordGyroViewController = RecordGyroViewController()
        
        navigationController?.pushViewController(recordGyroViewController, animated: true)
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = dataSource
        tableView.backgroundColor = .gray
        
        view.addSubview(tableView)
    }
    
    private func layout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -8)
            ])
    }
}
