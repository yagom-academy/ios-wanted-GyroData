//
//  ListViewController.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/01/30.
//

import UIKit

final class ListViewController: UIViewController {
    
    private typealias DataSource = UITableViewDiffableDataSource<Section, Measurement>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Measurement>
    
    private let measurements: [Measurement] = []
    private let listView: ListView = ListView()
    private var dataSource: DataSource? = nil
    private var snapShot: SnapShot = SnapShot()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = listView
        registerListCell()
        configureDataSource()
        applySnapshot()
    }
    
    private func registerListCell() {
        listView.tableView.register(ListCell.self,
                                    forCellReuseIdentifier: ListCell.reuseIdentifier)
    }
    
    private func configureDataSource() {
        let tableView = listView.tableView
        
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, measurement in
            let cellIdentifier = ListCell.reuseIdentifier
            
            let listCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
                    as? ListCell
            
            listCell?.setup(date: measurement.date.description,
                       sensorName: measurement.sensor.name,
                       value: String(measurement.time))
        
            return listCell
        }
    }
    
    private func applySnapshot() {
        snapShot.appendSections([.main])
        snapShot.appendItems(measurements)
        dataSource?.apply(snapShot)
    }
}

extension ListViewController {
    private enum Section {
        case main
    }
}
