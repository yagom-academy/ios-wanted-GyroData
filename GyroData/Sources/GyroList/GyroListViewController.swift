//
//  GyroListViewController.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import UIKit
import Combine

final class GyroListViewController: UIViewController {
    enum Section {
        case main
    }
    
    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Section, GyroData>?
    private let viewModel = GyroListViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationItems()
        setupTableView()
        layout()
        setupDataSource()
        bind()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationItems() {
        let title = "목록"
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        navigationItem.titleView = titleLabel
        
        let rightBarButtonTitle = "측정"
        let rightBarButton = UIBarButtonItem(title: rightBarButtonTitle,
                                             image: nil,
                                             target: self,
                                             action: #selector(recordGyro))
        rightBarButton.setTitleTextAttributes([.font: UIFont.preferredFont(forTextStyle: .title2)], for: .normal)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc private func recordGyro() {        
        let recordGyroViewController = RecordGyroViewController()
        
        navigationController?.pushViewController(recordGyroViewController, animated: true)
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GyroListCell.self, forCellReuseIdentifier: GyroListCell.reuseIdentifier)
        tableView.dataSource = dataSource
        
        view.addSubview(tableView)
    }
    
    private func layout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, GyroData>(tableView: tableView) { [weak self] tableView, indexPath, gyroData in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: GyroListCell.reuseIdentifier,
                for: indexPath) as? GyroListCell else {
                return UITableViewCell()
            }
            
            guard let dataForCell = self?.viewModel.formatGyroDataToString(gyroData: gyroData) else {
                return UITableViewCell()
            }
            
            cell.configure(date: dataForCell.date, type: dataForCell.dataType, duration: dataForCell.duration)
            
            return cell
        }
    }
    
    private func bind() {
        viewModel.gyroDataPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gyroDataList in
                self?.applyVideoListCellSnapshot(by: gyroDataList)
            }
            .store(in: &subscriptions)
    }
    
    private func applyVideoListCellSnapshot(by gyroDataList: [GyroData]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, GyroData>()

        snapshot.appendSections([.main])
        snapshot.appendItems(gyroDataList)

        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
