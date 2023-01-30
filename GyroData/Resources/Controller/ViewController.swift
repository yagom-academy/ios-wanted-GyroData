//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

final class ViewController: UIViewController {

    // MARK: - Property
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let cellReuseIdentifier = "CustomCell"
    private var cellCount = 10

    // MARK: - Method
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.separatorStyle = .none
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        configureSubViews()
    }

    private func configureSubViews() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? CustomTableViewCell ?? CustomTableViewCell()
        return customCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/6
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let playAction = UIContextualAction(style: .normal, title: "Play") { (action, view, completionHandler) in
            print("play 클릭")
            completionHandler(false)
        }
        playAction.backgroundColor = .systemGreen

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            print("delete 클릭")
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [deleteAction, playAction])
    }
}

