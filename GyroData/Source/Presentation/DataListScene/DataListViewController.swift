//
//  DataListViewController.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/31.
//

import UIKit

protocol DataListConfigurable {
    func setupData(_ datas: [MeasureData])
    func setupSelectData(_ data: MeasureData)
}

final class DataListViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Section, MeasureData>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MeasureData>

    private enum Constant {
        static let title = "목록"
    }
    
    enum Section {
        case main
    }
    
    private let tableView = UITableView()
    
    private lazy var viewModel = DataListViewModel(delegate: self)
    private lazy var dataSource = configureDataSoruce()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupConstraint()
    }
}

// MARK: - DataListConfigurable
extension DataListViewController: DataListConfigurable {
    func setupData(_ datas: [MeasureData]) {
        applySnapshot(datas: datas, true)
    }
    
    func setupSelectData(_ data: MeasureData) {
        //TODO: Receive To DetailViewController
    }
}

// MARK: - Configure DataSource, Snapshot
extension DataListViewController {
    private func configureDataSoruce() -> DataSource {
        let dataSource = DataSource(tableView: tableView) { tableView, indexPath, data in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MeasureDataCell.identifier,
                for: indexPath
            ) as? MeasureDataCell else {
                
                let errorCell = UITableViewCell()
                return errorCell
            }
            
            //TODO: Cell Setup
            return cell
        }
        return dataSource
    }
    
    private func applySnapshot(datas: [MeasureData], _ animaingDifferences: Bool) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(datas)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension DataListViewController {
    private func setupNavigationBar() {
        title = Constant.title
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGray5
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupView() {
        view.addSubview(tableView)
        view.backgroundColor = .white
    }
    
    private func setupConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}
