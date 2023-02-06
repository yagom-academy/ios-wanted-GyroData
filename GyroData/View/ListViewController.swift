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
    
    private var listViewModel = ListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "목록"
        
        let measurementButtonAction = UIAction { [weak self] _ in
            let measurementViewController = MeasurementViewController()
            self?.navigationController?.pushViewController(measurementViewController, animated: true)
        }

        let measurementButtonItem = UIBarButtonItem(title: "측정", primaryAction: measurementButtonAction)
        
        navigationItem.rightBarButtonItem = measurementButtonItem
    }
    
    private func configureTableView() {
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
    
    private func bind() {
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
        // view 상태로 가게 됨
        guard let information = listViewModel.gyroInformations.value else { return }
        let nextViewController = ReplayViewController(
            replayViewModel: ReplayViewModel(
                information: information[indexPath.row]
            )
        )

        present(nextViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let playAction = makePlayAction(tableView, indexPath: indexPath)
        let deleteAction = makeDeleteAction(tableView, indexPath: indexPath)
        let configuration = UISwipeActionsConfiguration(actions: [playAction, deleteAction])
        return configuration
    }

    func makePlayAction(_ tableView: UITableView, indexPath: IndexPath) -> UIContextualAction {
        let playAction = UIContextualAction(style: .normal, title: "Play") { [weak self] _,_,_  in
            // play 상태로 가게 됨
            guard let information = self?.listViewModel.gyroInformations.value else { return }
            let nextViewController = ReplayViewController(
                replayViewModel: ReplayViewModel(
                    information: information[indexPath.row]
                )
            )

            self?.present(nextViewController, animated: true)
        }

        return playAction
    }

    func makeDeleteAction(_ tableView: UITableView, indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] _,_,_  in
            guard let information = self?.listViewModel.gyroInformations.value else { return }

            self?.listViewModel.deleteGyroInformation(information[indexPath.row])
        }

        return deleteAction
    }
}

extension ListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView.contentOffset.y > tableView.contentSize.height - tableView.bounds.size.height {
            if listViewModel.isLoading.value == false {
                listViewModel.fetchGyroInformations(limit: 10)
            }
        }
    }
}
