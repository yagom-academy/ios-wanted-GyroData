//
//  MotionDataTableViewController.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2022/09/16.
//

import UIKit

final class MotionDataTableViewController: UIViewController {

    private var motionDataListViewModel: MotionDataTableViewModel?
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, MotionData>?

    init(motionDataListViewModel: MotionDataTableViewModel? = MotionDataTableViewModel()) {
        self.motionDataListViewModel = motionDataListViewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()

        configureDataSource()
        configureSnapshot(list: motionDataListViewModel?.fetchMotionDataList() ?? [])
    }

    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        view.addSubview(collectionView)
    }

    private func configureLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension MotionDataTableViewController {

    private func createListLayout() -> UICollectionViewCompositionalLayout {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)

        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        return listLayout
    }

    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, MotionData> { (cell, indexPath, motionData) in
        }

        dataSource = UICollectionViewDiffableDataSource<Int, MotionData>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, motionData: MotionData) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: motionData)
        }
    }

    func configureSnapshot(list: [MotionData]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, MotionData>()
        snapshot.appendItems(list)

        dataSource?.apply(snapshot)
    }
}

extension MotionDataTableViewController {

    private func handleSwipe(for action: UIContextualAction, item: MotionData) {

        let alert = UIAlertController(title: action.title,
                                      message: String(item.time),
                                      preferredStyle: .alert)

        let okAction = UIAlertAction(title:"OK", style: .default, handler: { (_) in })
        alert.addAction(okAction)

        present(alert, animated: true, completion:nil)
    }
}
