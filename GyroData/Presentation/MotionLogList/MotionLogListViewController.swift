//
//  MotionLogListViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//


import UIKit

fileprivate enum Titles {
    static let navigationItemTitle = "목록"
    static let leftNavigationButtonTitle = "측정"
}

final class MotionLogListViewController: UIViewController {
    enum Section {
        case main
    }
    
    var viewModel: MotionLogListViewModel?
    private var dataSource: UICollectionViewDiffableDataSource<Section, MotionLogCellViewModel>?
    
    // MARK: View(s)
    
    private let motionLogListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: .init()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        combineViews()
        configureViewStyles()
        configureViewConstraints()
        configureNavigationItems()
        configureMotionLogListCollectionView()
        bindViewModel()
    }
    
    //MARK: Private Function(s)
    
    private func bindViewModel() {
        viewModel?.bind{ [weak self] items in
            self?.updateSnapshot(with: items)
        }
    }
    
    private func updateSnapshot(with items: [MotionLogCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MotionLogCellViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        self.dataSource?.apply(snapshot)
    }
    
    private func configureMotionLogListCollectionView() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        motionLogListCollectionView.collectionViewLayout = layout
        
        configureDataSource()
    }
    
    private func createListCellRegistration()
    -> UICollectionView.CellRegistration<MotionLogCell, MotionLogCellViewModel> {
        let registration = UICollectionView
            .CellRegistration<MotionLogCell, MotionLogCellViewModel>
            .init { cell, _, item in
                cell.configure(with: item)
            }
        return registration
    }
    
    private func configureDataSource() {
        let registration = createListCellRegistration()
        dataSource = UICollectionViewDiffableDataSource<Section, MotionLogCellViewModel>(
            collectionView: motionLogListCollectionView
        ) { collectionView, indexPath, item in
            
            let cell = collectionView
                .dequeueConfiguredReusableCell(
                    using: registration,
                    for: indexPath,
                    item: item
                )
            cell.configure(with: item)
            
            return cell
        }
        motionLogListCollectionView.dataSource = dataSource
    }
    
    private func configureNavigationItems() {
        let leftNavigationButton = UIBarButtonItem(
            title: Titles.leftNavigationButtonTitle,
            style: .plain,
            target: self,
            action: #selector(tap)
        )
        navigationItem.title = Titles.navigationItemTitle
        navigationItem.rightBarButtonItem = leftNavigationButton
    }
    
    private func configureViewStyles() {
        motionLogListCollectionView.backgroundColor = .systemGray4
    }
    
    private func combineViews() {
        view.addSubview(motionLogListCollectionView)
    }
    
    private func configureViewConstraints() {
        NSLayoutConstraint.activate([
            motionLogListCollectionView.topAnchor
                .constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor
                ),
            motionLogListCollectionView.bottomAnchor
                .constraint(
                    equalTo: view.bottomAnchor
                ),
            motionLogListCollectionView.leadingAnchor
                .constraint(
                    equalTo: view.leadingAnchor
                ),
            motionLogListCollectionView.trailingAnchor
                .constraint(
                    equalTo: view.trailingAnchor
                ),
        ])
    }
    
    @objc
    func tap() {
        let view = MotionMeasurementViewController()
        let repository = CoreMotionRepository(dataSource: CoreMotionManager.shared)
        let useCase = TrackMotionUseCase(repository: repository)
        view.viewModel = MotionMeasurementViewModel(useCase: useCase)
        navigationController?.pushViewController(view, animated: true)
    }
}
