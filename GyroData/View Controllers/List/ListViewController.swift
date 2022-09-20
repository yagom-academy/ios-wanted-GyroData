//
//  ListViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

final class ListViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    var gyroDatas: [GyroData] = GyroData.sampleData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureLayout()
    }
    
    private func configureNavigation() {
        navigationItem.title = "목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정", style: .plain, target: self, action: #selector(didTapMeasureButton))
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc
    private func didTapMeasureButton() {
        
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gyroDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell else { return UITableViewCell()
        }
        let gyroData = gyroDatas[indexPath.row]
        cell.dateLabel.text = gyroData.dateString
        cell.keyLabel.text = gyroData.type.rawValue
        cell.valueLabel.text = "\(gyroData.value)"
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let playAction = UIContextualAction(style: .normal, title: "Play") { action, view, handler in
            print("touch Play Button")
        }
        playAction.backgroundColor = .systemGreen
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, handler in
            print("touch Delete Button")
        }
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [ deleteAction, playAction])
        return configuration
    }
}
