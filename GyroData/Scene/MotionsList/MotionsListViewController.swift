//
//  MotionsListViewController.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import UIKit

class MotionsListViewController: UIViewController {
    enum Constant {
        static let title = "목록"
        static let measurementButtonTitle = "측정"
        static let playActionTitle = "Play"
        static let deleteActionTitle = "Delete"
    }
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let measurementButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "측정", primaryAction: nil)
        return button
    }()
    
    private let viewModel: MotionsListViewModel
    private var dataSource: UITableViewDiffableDataSource<Int, Motion>?
    
    init(viewModel: MotionsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.action(.viewWillApear)
    }
}

// MARK: UI Componenets
extension MotionsListViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        navigationItem.title = Constant.title
        navigationItem.rightBarButtonItem = measurementButton
        
        tableView.register(MotionCell.self, forCellReuseIdentifier: MotionCell.reuseIdentifier)
        tableView.delegate = self
        viewModel.setDelegate(self)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

// MARK: Diffable DataSource
extension MotionsListViewController {
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Motion>(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, motion in
                guard let self,
                      let cell = tableView.dequeueReusableCell(withIdentifier: MotionCell.reuseIdentifier,
                                                               for: indexPath) as? MotionCell
                else {
                    return UITableViewCell()
                }
                
                let cellData = self.viewModel.fetchCellData(from: motion)
                cell.setUpCellData(date: cellData.date, measurementType: cellData.measurementType, time: cellData.time)
                
                return cell
            }
        )
    }
    
    private func updateSnapshot(with motions: [Motion]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Motion>()
        snapshot.appendSections([0])
        snapshot.appendItems(motions)
        dataSource?.apply(snapshot)
    }
}

// MARK: UITableViewDelegate
extension MotionsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.action(.motionTap(indexPath: indexPath))
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let playAction = UIContextualAction(style: .normal, title: "Play") { [weak self] _, view, completion in
            self?.viewModel.action(.motionDelete(indexPath: indexPath))
            completion(true)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.viewModel.action(.motionDelete(indexPath: indexPath))
            completion(true)
        }
        
        playAction.backgroundColor = .systemGreen
        playAction.image = UIImage(systemName: "play.fill")
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, playAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false

        return swipeConfiguration
    }
}

// MARK: MotionsListViewModelDelegate
extension MotionsListViewController: MotionsListViewModelDelegate {
    func motionsListViewModel(didChange motions: [Motion]) {
        updateSnapshot(with: motions)
    }
    
    func motionsListViewModel(selectedGraphMotionID id: String) {
        // present MotionGraphViewController
    }
    
    func motionsListViewModel(selectedPlayMotionID id: String) {
        // present MotionPlayViewController
    }
}

// MARK: UIScrollViewDelegate
extension MotionsListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard tableView.frame.height < scrollView.contentSize.height else { return }
        
        let endPoint: CGFloat = scrollView.contentOffset.y + scrollView.bounds.height
        let isEndOfScroll: Bool = endPoint >= scrollView.contentSize.height * 0.9
        
        if isEndOfScroll {
            print(endPoint)
            viewModel.action(.nextPageRequest)
        }
    }
}
