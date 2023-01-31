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

        configureUI()
        configureDataSource()
        configureSnapshot(list: motionDataListViewModel?.fetchMotionDataList() ?? [])
        configureViewModel()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureCollection()
        configureLayout()
        configureNavigationBar()
    }

    private func configureCollection() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        collectionView.register(MotionListCell.self,
                                forCellWithReuseIdentifier: MotionListCell.reuseIdentifier)
        collectionView.delegate = self
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
    
    private func configureNavigationBar() {
        navigationItem.title = "목록"
        navigationItem.rightBarButtonItem = createMeasurementButton()
    }
    
    private func configureViewModel() {
        motionDataListViewModel?.bindMotionDataList { [weak self] in
            self?.configureSnapshot(list: self?.motionDataListViewModel?.fetchMotionDataList() ?? [])
        }
    }
    
    private func createMeasurementButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "측정", primaryAction: createPushAction())
        
        return button
    }
    
    private func createPushAction() -> UIAction {
        let action = UIAction { _ in
            let measurementMotionDataViewController = MeasurementMotionDataViewController()
//            self.navigationController?.pushViewController(measurementMotionDataViewController, animated: true)
            
            self.motionDataListViewModel?.creatMotionData()
        }
        
        return action
    }
}

extension MotionDataTableViewController {

    private func createListLayout() -> UICollectionViewCompositionalLayout {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        layoutConfig.showsSeparators = false

        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)

        return listLayout
    }

    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MotionListCell, MotionData> { (cell, indexPath, motionData) in
            cell.timeLabel.text = motionData.time.description
            cell.typeLabel.text = motionData.type.rawValue
            cell.dateLabel.text = motionData.date.description
        }

        dataSource = UICollectionViewDiffableDataSource<Int, MotionData>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, motionData: MotionData) -> MotionListCell in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: motionData)
        }
    }

    func configureSnapshot(list: [MotionData]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, MotionData>()
        snapshot.appendSections([0])
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

extension MotionDataTableViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let replayMotionViewControll = ReplayMotionViewController()
        navigationController?.pushViewController(replayMotionViewControll, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
