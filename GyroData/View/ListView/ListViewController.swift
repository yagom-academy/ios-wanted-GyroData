//
//  ListViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

final class ListViewController: UIViewController {
    private let listViewModel = DefaultListViewModel()
    private let listView = ListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        setupNavigationBar()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listViewModel.fetchData()
    }
    
    @objc func rightButtonTapped() {
        let vc = MeasureViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listViewModel.models.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListViewCell.identifier, for: indexPath) as! ListViewCell
        cell.setupData(with: listViewModel.models.value[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController(data: listViewModel.models.value[indexPath.row], type: .view)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let playAction = generatePlayAction(with: indexPath.row)
        let deleteAction = generateDeleteAction(with: indexPath.row)
        return UISwipeActionsConfiguration(actions: [deleteAction, playAction])
    }
    
    func generatePlayAction(with indexPath: Int) -> UIContextualAction {
        let playAction = UIContextualAction(style: .normal, title: "Play") { [weak self] _, _, _ in
            guard let self = self else { return }
            let vc = DetailViewController(data: self.listViewModel.models.value[indexPath], type: .play)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        playAction.backgroundColor = .init(red: 19/255, green: 144/225, blue: 14/225, alpha: 1)
        return playAction
    }
    
    func generateDeleteAction(with indexPath: Int) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self]_, _, _ in
            guard let self = self else { return }
            let data = self.listViewModel.models.value[indexPath]
            self.listViewModel.deleteData(data: data)
        }
        return deleteAction
    }
}

private extension ListViewController {
    
    func setupInitialView() {
        self.view = listView
        listView.backgroundColor = .systemBackground
        listView.tableView.delegate = self
        listView.tableView.dataSource = self
    }
    
    func setupBinding() {
        listViewModel.models.bind { [weak self] _ in
            self?.listView.tableView.reloadData()
        }
    }
    
    func setupNavigationBar() {
        let rightButton: UIBarButtonItem = {
             let button = UIBarButtonItem(
                title: "측정",
                style: .plain,
                target: self,
                action: #selector(rightButtonTapped)
             )
             
             return button
         }()
        self.navigationItem.title = "목록"
        self.navigationItem.rightBarButtonItem = rightButton
    }
}
