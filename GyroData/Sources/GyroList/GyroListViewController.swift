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
    
    private let loadingIndicatorView = UIActivityIndicatorView(style: .large)
    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Section, GyroData>?
    private let viewModel = GyroListViewModel()
    private var subscriptions = Set<AnyCancellable>()
    private var isPaging = false
    private var isNoMoreData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationItems()
        setupTableView()
        setupLoadingIndicatorView()
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
    
    private func setupLoadingIndicatorView() {
        loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loadingIndicatorView)
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GyroListCell.self, forCellReuseIdentifier: GyroListCell.reuseIdentifier)
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        view.addSubview(tableView)
    }
    
    private func layout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -8),
            
            loadingIndicatorView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            loadingIndicatorView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            loadingIndicatorView.widthAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 0.4),
            loadingIndicatorView.heightAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 0.4)
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
                self?.isPaging = false
                self?.configureLoadingStatus()
            }
            .store(in: &subscriptions)
        
        viewModel.isNoMoreDataPublisher()
            .assign(to: \.isNoMoreData, on: self)
            .store(in: &subscriptions)
    }
    
    private func applyVideoListCellSnapshot(by gyroDataList: [GyroData]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, GyroData>()

        snapshot.appendSections([.main])
        snapshot.appendItems(gyroDataList)

        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Table view delegate
extension GyroListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPlayGyro(seletedIndexPath: indexPath, viewMode: .view)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let play = UIContextualAction(style: .normal, title: "Play") { [weak self] _, _, _ in
            self?.showPlayGyro(seletedIndexPath: indexPath, viewMode: .play)
        }
        
        play.backgroundColor = .systemGreen
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            self?.viewModel.deleteGyroData(at: indexPath.item)
        }
        
        return UISwipeActionsConfiguration(actions: [delete, play])
    }
    
    private func showPlayGyro(seletedIndexPath: IndexPath, viewMode: PlayGyroViewController.Mode) {
        guard let selectedItem = dataSource?.itemIdentifier(for: seletedIndexPath) else {
            return
        }
        
        let playGyroViewController = PlayGyroViewController(viewMode: viewMode,
                                                            gyroData: selectedItem)
        
        navigationController?.pushViewController(playGyroViewController, animated: true)
    }
}

// MARK: - Scroll view delegate for pagination
extension GyroListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        let isScrollingBottom = offsetY > (contentHeight - height)
        
        if isScrollingBottom && !isNoMoreData && !isPaging {
            requestMorePage()
        }
    }
    
    private func requestMorePage() {
        isPaging = true
        configureLoadingStatus()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.viewModel.requestFetch()
        }
    }
    
    private func configureLoadingStatus() {
        loadingIndicatorView.isHidden = !isPaging
        
        if isPaging {
            loadingIndicatorView.startAnimating()
        } else {
            loadingIndicatorView.stopAnimating()
        }
    }
}
