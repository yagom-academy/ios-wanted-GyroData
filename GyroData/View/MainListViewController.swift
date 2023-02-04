//
//  MainListViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

final class MainListViewController: UIViewController {
    private let viewModel = MainListViewModel()
    
    private let tableView: UITableView = {
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
        configureBind()
    }
    
    private func configureNavigationBar() {
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
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.clearData()
        viewModel.fetchData()
    }

    private func configureLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
    }
    private func configureBind() {
        viewModel.bindTableView {
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - TableViewDelegate, DataSoruce
extension MainListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.motionDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
            return ListCell()
        }
        
        cell.configureData(viewModel: ListCellViewModel(motionEntity: viewModel.motionDataList[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let measureDetailViewModel =  MeasureDetailViewModel(motionData: viewModel.motionDataList[indexPath.row],
                                                             pageType: .view)
        let measureDetailViewController = MeasureDetailViewController(viewModel: measureDetailViewModel)
        
        self.navigationController?.pushViewController(measureDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.viewModel.deleteData(dataIndex: indexPath.row)
            success(true)
        }
        
        delete.backgroundColor = .systemRed
        
        let play = UIContextualAction(style: .normal, title: "Play") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            let measureDetailViewModel =  MeasureDetailViewModel(motionData: self.viewModel.motionDataList[indexPath.row],
                                                                 pageType: .play)
            
            let measureDetailViewController = MeasureDetailViewController(viewModel: measureDetailViewModel)
            self.navigationController?.pushViewController(measureDetailViewController, animated: true)
            success(true)
        }
        play.backgroundColor = .systemGreen
        
        return UISwipeActionsConfiguration(actions:[delete, play])
    }
}

// MARK: - Paging
extension MainListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > (contentHeight - height) {
            viewModel.paing()
        }
    }
}
