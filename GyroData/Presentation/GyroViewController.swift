//
//  GyroViewController.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/26.
//

import UIKit

final class GyroViewController: UIViewController {
    private let dummy = [
        Motion(
            date: "2022/12/28 14:50:43",
            measurementType: "Acc",
            coordinate: Coordinate(x: [1], y: [2], z: [3])
        ),
        
        Motion(
            date: "2022/12/29 15:42:13",
            measurementType: "Acc",
            coordinate: Coordinate(x: [4], y: [5], z: [6])
        )
    ]
    
    private enum Section {
        case main
    }
    
    private var dataSource: UITableViewDiffableDataSource<Section, Motion>?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Motion>()
    private let gyroListView = GyroTableView()
    private let coreDataManager = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupSubviews()
        setupLayout()
        setupDefault()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "목록"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "측정",
            style: .plain,
            target: self,
            action: #selector(moveMeasureView)
        )
    }
    
    private func setupDefault() {
        gyroListView.register(GyroTableViewCell.self, forCellReuseIdentifier: "measurementListViewCell")
        gyroListView.delegate = self
        gyroListView.translatesAutoresizingMaskIntoConstraints = false
        
        dataSource = UITableViewDiffableDataSource<Section, Motion>(
            tableView: gyroListView,
            cellProvider: { tableView, indexPath, itemIdentifier in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "measurementListViewCell",
                    for: indexPath
                ) as? GyroTableViewCell else {
                    return nil
                }

                cell.configure(motion: itemIdentifier)
                return cell
            })
        
        snapshot.appendSections([.main])
        snapshot.appendItems(dummy)
        
        dataSource?.apply(snapshot)
    }

    private func setupSubviews() {
        view.addSubview(gyroListView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            gyroListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gyroListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gyroListView.topAnchor.constraint(equalTo: view.topAnchor),
            gyroListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func moveMeasureView() {
        self.navigationController?.pushViewController(
            MeasureViewController(),
            animated: true
        )
    }
}

extension GyroViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        self.navigationController?.pushViewController(
            ReplayViewController(pageType: ReplayViewPageType.view),
            animated: true
        )
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let playAction = UIContextualAction(
            style: .normal,
            title: "Play"
        ) { [weak self] _, _, _ in
            
            guard let self = self else {
                return
            }
            
            self.navigationController?.pushViewController(
                ReplayViewController(pageType: ReplayViewPageType.play),
                animated: true
            )
        }
        playAction.backgroundColor = .green
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "delete"
        ) { [weak self] _, _, _ in
            
            guard let self = self else {
                return
            }
            
            let data = self.snapshot.itemIdentifiers[indexPath.item]
            self.snapshot.deleteItems([data])
            self.dataSource?.applySnapshotUsingReloadData(self.snapshot)
        }
    
        return UISwipeActionsConfiguration(actions: [deleteAction, playAction])
    }
}
