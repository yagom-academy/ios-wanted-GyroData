//
//  ListViewController.swift
//  GyroData
//
//  Created by ash and som on 2023/02/01.
//

import UIKit

final class ListViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListTableViewCell.self,
                           forCellReuseIdentifier: ListTableViewCell.self.description())
        return tableView
    }()
    
    private let listViewModel = ListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureNavigationbar() {
        navigationItem.title = "목록"
        
        let measurementButtonAction = UIAction { [weak self] _ in
            self?.present(GyroMeasurementViewController(), animated: true)
        }
        
        let measurementButtonItem = UIBarButtonItem()
        measurementButtonItem.title = "측정"
        measurementButtonItem.style = .plain
        measurementButtonItem.primaryAction = measurementButtonAction
        
        navigationItem.rightBarButtonItem = measurementButtonItem
        
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func bind() {
        listViewModel.gyroInformations.bind { _ in
            self.tableView.reloadData()
        }
        
        listViewModel.numberOfRowsInSection.bind { _ in
            self.tableView.reloadData()
        }
        
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.numberOfRowsInSection.value ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.self.description(),
                                                       for: indexPath) as? ListTableViewCell,
              let cellItem = listViewModel.gyroInformations.value?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configureCell(cellItem)
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cellItem 넘겨주는 코드 추후 필요
        // view 상태로 가게 됨
        let nextViewController = GyroReplayViewController()
        present(nextViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let playAction = makePlayAction(tableView, indexPath: indexPath)
        let deleteAction = makeDeleteAction(tableView, indexPath: indexPath)
        let configuration = UISwipeActionsConfiguration(actions: [playAction, deleteAction])
        return configuration
    }
    
    func makePlayAction(_ tableView: UITableView, indexPath: IndexPath) -> UIContextualAction {
        let play = UIContextualAction(style: .normal, title: "Play") { _ in
            guard let cellItem = tableView.dataSource.itemIdentifier(for: indexPath) else { return }
            
            // cellItem 넘겨주는 코드 추후 필요
            // play 상태로 가게 됨
            let nextViewController = GyroReplayViewController()
            present(nextViewController, animated: true)
        }
    }
    
    func makeDeleteAction(_ tableView: UITableView, indexPath: IndexPath) -> UIContextualAction {
        let delete = UIContextualAction(style: .normal, title: "Delete") { _ in
            guard let cellItem = tableView.dataSource.itemIdentifier(for: indexPath) else { return }
            
            listViewModel.deleteGyroInformation(cellItem)
        }
    }
}

extension ListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView.contentOffset.y > tableView.contentSize.height - tableView.bounds.size.height {
            if !listViewModel.isLoading {
                listViewModel.fetchGyroInformations(limit: 10)
            }
        }
    }
}
