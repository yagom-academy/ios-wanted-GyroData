//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

class ViewController: UIViewController {
    let manager = CoreDataManager.shared
    var motionDataList: [MotionEntity] = []
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureTableView()
        configureLayout()
        configureData()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(rightButtonTapped))
    }
    
    @objc func rightButtonTapped() {
        let measureViewController = MeasureViewController()
        navigationController?.pushViewController(measureViewController, animated: true)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
    }
    
    func configureData() {
        guard let hasList = manager.fetchData(entity: MotionEntity.self) else { return }
        motionDataList = hasList
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return motionDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
            return ListCell()
        }
    
        cell.configureData(title: motionDataList[indexPath.row].measureType,
                           date: motionDataList[indexPath.row].date,
                           second: motionDataList[indexPath.row].time)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.manager.delete(entity: self.motionDataList[indexPath.row])
            self.motionDataList.remove(at: indexPath.row)
            success(true)
            tableView.reloadData()
        }
        
        delete.backgroundColor = .systemRed
        
        let play = UIContextualAction(style: .normal, title: "Play") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            success(true)
        }
        play.backgroundColor = .systemGreen
        
        return UISwipeActionsConfiguration(actions:[delete, play])
    }
}
