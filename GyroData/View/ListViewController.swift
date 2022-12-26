//
//  ListViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

final class ListViewController: UIViewController {
    private let listView = ListView()
    private var list = [CellData(date: Date().translateToString(), sensorValue: "43.4", sensor: "Accelerometer")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
    }
    
    private func setupInitialView() {
        self.view = listView
        listView.backgroundColor = .systemBackground
        listView.tableView.delegate = self
        listView.tableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListViewCell.identifier, for: indexPath) as! ListViewCell
        cell.setupData(with: list[indexPath.row])
        
        return cell
    }
}
