//  GyroData - ViewController.swift
//  Created by zhilly, woong on 2023/01/31

import UIKit

class MeasureListViewController: UIViewController {
    
    enum Schedule: Hashable {
        case main
    }
    
    struct SampleData: Hashable {
        var createdAt: String
        var sensorType: String
        var measureTime: String
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Schedule, SampleData>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Schedule, SampleData>
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.separatorStyle = .none
        tableView.register(MeasureTableViewCell.self,
                           forCellReuseIdentifier: "MeasureTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private var dataSource: DataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = setupTableViewDataSource()
        setupNavigation()
        setupViews()
        tableView.delegate = self
        appendData()
    }
    
    private func setupNavigation() {
        navigationItem.title = "목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(presentMeasureViewController))
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
    
    private func setupTableViewDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MeasureTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? MeasureTableViewCell else { return UITableViewCell() }
            
            cell.configure()
            
            return cell
        }
        
        return dataSource
    }
    
    private func appendData() {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems([
            SampleData(createdAt: "1", sensorType: "", measureTime: ""),
            SampleData(createdAt: "2", sensorType: "", measureTime: ""),
            SampleData(createdAt: "3", sensorType: "", measureTime: "")
        ])
        dataSource?.apply(snapshot)
    }
    
    @objc
    private func presentMeasureViewController() {
        self.navigationController?.pushViewController(MeasureViewController(), animated: true)
    }
}

extension MeasureListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let playAction = UIContextualAction(style: .normal,
                                            title: "Play") { (_, _, success) in
            
        }
        playAction.backgroundColor = .systemGreen
        
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Delete") { (_, _, success) in
            
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction,playAction])
    }
}
