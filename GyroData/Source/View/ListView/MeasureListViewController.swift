//  GyroData - ViewController.swift
//  Created by zhilly, woong on 2023/01/31

import UIKit

final class MeasureListViewController: UIViewController {
    
    private enum Constant {
        static let title = "목록"
        static let measureButtonTitle = "측정"
        static let playSwipeAction = "Play"
        static let deleteSwipeAction = "Delete"
    }
    
    enum Schedule: Hashable {
        case main
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Schedule, MotionData>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Schedule, MotionData>
    
    private var dataSource: DataSource?
    private var measureListViewModel: MeasureListViewModel
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.separatorStyle = .none
        tableView.register(MeasureTableViewCell.self,
                           forCellReuseIdentifier: MeasureTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    init(dataSource: DataSource? = nil, measureListViewModel: MeasureListViewModel) {
        self.dataSource = dataSource
        self.measureListViewModel = measureListViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        dataSource = setupTableViewDataSource()
        setupNavigation()
        setupViews()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.measureListViewModel.fetchToCoreData()
    }
    
    private func bind() {
        measureListViewModel.model.bind { [weak self] item in
            self?.appendData(item: item)
        }
    }
    
    private func setupNavigation() {
        let pushMeasureViewAction = UIAction { [weak self] _ in
            let measurViewModel = MeasureViewModel()
            let measureViewController = MeasureViewController(measureViewModel: measurViewModel)
            self?.push(viewController: measureViewController)
        }
        
        navigationItem.title = Constant.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constant.measureButtonTitle,
                                                            primaryAction: pushMeasureViewAction)
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableViewDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MeasureTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? MeasureTableViewCell else { return UITableViewCell() }
            
            cell.configure(createdAt: item.createdAt,
                           sensorType: item.sensorType.rawValue,
                           runtime: item.runtime)
            
            return cell
        }
        
        return dataSource
    }
    
    private func appendData(item: [MotionData]) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(item)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func push(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MeasureListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let createdAt = measureListViewModel.model.value[indexPath.row].createdAt
        let detailViewController = DetailViewController(detailViewMode: .view,
                                                        createdAt: createdAt)
        push(viewController: detailViewController)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let playAction = UIContextualAction(style: .normal,
                                            title: Constant.playSwipeAction) { [weak self] (_, _, success) in
            guard let createdAt = self?.measureListViewModel.model.value[indexPath.row].createdAt else { return }
            let detailViewController = DetailViewController(detailViewMode: .play,
                                                            createdAt: createdAt)
            self?.push(viewController: detailViewController)
        }
        playAction.backgroundColor = .systemGreen
        
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: Constant.deleteSwipeAction) { [weak self] (_, _, success) in
            self?.measureListViewModel.delete(index: indexPath.row)
            success(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction,playAction])
    }
}
