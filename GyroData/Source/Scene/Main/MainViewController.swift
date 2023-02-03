//
//  MainViewController.swift
//  GyroData
//
//  Created by Baem, Dragon on 2022/09/16.
//

import UIKit

final class MainViewController: UIViewController {
    // MARK: Private Properties
    private var motionDataList: [Motion] = []
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomDataCell.self, forCellReuseIdentifier: CustomDataCell.identifier)
        return tableView
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchMotionCoreData()
    }
    
    // MARK: Private Methods
    
    private func fetchMotionCoreData() {
        if let motionData = fetchMotionData() {
            motionDataList = motionData
            
            tableView.reloadData()
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureView() {
        let titleView = NavigationTitleView()
        titleView.configureTitleLabel(title: "목록")
        
        view.backgroundColor = .systemBackground
        navigationItem.titleView = titleView
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: String(),
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.backBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "측정",
            style: .plain,
            target: self,
            action: #selector(tapRightBarButton)
        )
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: Action Methods
    
    @objc private func tapRightBarButton() {
        let addViewController = AddViewController()
        
        navigationController?.pushViewController(addViewController, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let playAction = UIContextualAction(
            style: .normal,
            title: "Play"
        ) { _, _, _ in
            let data = self.motionDataList[indexPath.row]
            let replayViewController = ReplayViewController(mode: .play, motionData: data)
            
            self.navigationController?.pushViewController(replayViewController, animated: true)
        }
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { _, _, _ in
            let deleteData = self.motionDataList.remove(at: indexPath.row)
            guard let id = deleteData.id else { return }
            
            self.deleteDate(id: id)
            tableView.reloadData()
        }
        
        playAction.backgroundColor = .systemGreen
        
        return UISwipeActionsConfiguration(actions: [deleteAction, playAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.motionDataList[indexPath.row]
        let replayViewController = ReplayViewController(mode: .view, motionData: data)
        
        navigationController?.pushViewController(replayViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return motionDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CustomDataCell.identifier,
            for: indexPath
        ) as? CustomDataCell else {
            return UITableViewCell()
        }
        let motionData = motionDataList[indexPath.row]
        
        cell.configureLabel(data: motionData)
        
        return cell
    }
}

// MARK: - CoreDataProcessible

extension MainViewController: CoreDataProcessible {
    func fetchMotionData() -> [Motion]? {
        let result = readCoreData()
        
        switch result {
        case .success(let data):
            return data
        case .failure(_):
            return nil
        }
    }
}
