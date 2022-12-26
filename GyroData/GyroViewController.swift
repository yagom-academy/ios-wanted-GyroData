//
//  GyroViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

final class GyroViewController: UIViewController {
    
    private let gyroListView = GyroTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupDefault()
        setupSubviews()
        setupLayout()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "목록"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정",
                                                            style: .plain,
                                                            target: self,
                                                            action: nil)
    }
    
    private func setupDefault() {
        gyroListView.delegate = self
        gyroListView.dataSource = self
        gyroListView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSubviews() {
        view.addSubview(gyroListView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            gyroListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gyroListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gyroListView.topAnchor.constraint(equalTo: view.topAnchor),
            gyroListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension GyroViewController: UITableViewDelegate {    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let playAction = UIContextualAction(style: .normal,
                                            title: "Play") { action, view, completionHaldler in
            completionHaldler(true)
        }
        playAction.backgroundColor = .green
        
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "delete") { action, view, completionHaldler in
            completionHaldler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, playAction])
    }
}

extension GyroViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GyroTableViewCell.id) as? GyroTableViewCell ?? GyroTableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = CGFloat(80)
        return height
    }
}
