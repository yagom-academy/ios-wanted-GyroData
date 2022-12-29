//
//  GyroViewController.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/26.
//

import UIKit

final class GyroViewController: UIViewController {
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
    
    override func viewWillAppear(_ animated: Bool) {
        MotionDataLoad()
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

    private func MotionDataLoad() {
        let snapshotCount = dataSource?.snapshot().numberOfItems ?? 0
        let coreDataList = coreDataManager.fetch(
            request: MotionEntity.fetchRequest()
        )
        
        if snapshotCount < coreDataList.count {
            let coreData = coreDataManager.fetch(
                request: MotionEntity.fetchRequestWithOptions(
                    offset: snapshotCount
                )
            )
            
            snapshot.appendItems(coreData)
            dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
}

extension GyroViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.bounds.height) {
            MotionDataLoad()
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let motion = self.dataSource?.snapshot().itemIdentifiers[indexPath.item] else {
            return
        }
        
        let replayViewController = ReplayViewController()
        weak var sendDataDelegate: SendDataDelegate? = replayViewController
        sendDataDelegate?.sendData(MotionInfo(data: motion, pageType: ReplayViewPageType.view))
        
        self.navigationController?.pushViewController(
            replayViewController,
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
            
            guard let self = self,
                  let motion = self.dataSource?.snapshot().itemIdentifiers[indexPath.item] else {
                return
            }

            let replayViewController = ReplayViewController()
            weak var sendDataDelegate: SendDataDelegate? = replayViewController
            sendDataDelegate?.sendData(MotionInfo(data: motion, pageType: ReplayViewPageType.play))
            
            self.navigationController?.pushViewController(
                replayViewController,
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
            self.coreDataManager.delete(data: data)
            self.snapshot.deleteItems([data])
            self.dataSource?.applySnapshotUsingReloadData(self.snapshot)
        }
    
        return UISwipeActionsConfiguration(actions: [deleteAction, playAction])
    }
}
