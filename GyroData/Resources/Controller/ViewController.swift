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

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? CustomTableViewCell ?? CustomTableViewCell()
        return customCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/6
    }
}

extension ViewController: UITableViewDelegate {

}

