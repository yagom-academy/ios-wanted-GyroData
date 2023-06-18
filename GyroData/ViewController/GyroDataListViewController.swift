//
//  GyroDataListViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit
import Combine

final class GyroDataListViewController: UIViewController {
    enum Section {
        case main
    }
    
    private let viewModel: GyroDataListViewModel
    private let measureViewModel: MeasureViewModel
    private let detailViewModel: DetailViewModel
    
    private var dataSource: UITableViewDiffableDataSource<Section, GyroEntity>?
    private var cancellables = Set<AnyCancellable>()

    private var isPaging: Bool = false
    private var isNoMoreData: Bool = false
    private let loadingIndicatorView = UIActivityIndicatorView(style: .large)
    
    private let gyroDataTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(GyroDataTableViewCell.self, forCellReuseIdentifier: GyroDataTableViewCell.identifier)
        
        return tableView
    }()
    
    init(viewModel: GyroDataListViewModel, measureViewModel: MeasureViewModel, detailViewModel: DetailViewModel) {
        self.viewModel = viewModel
        self.measureViewModel = measureViewModel
        self.detailViewModel = detailViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gyroDataTableView.delegate = self
        setUpView()
        configureGyroDataTableView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
    }
    
    private func bind() {
        viewModel.$gyroData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.createSnapshot(data)
                self?.isPaging = false
                self?.configureLoadingStatus()
            }
            .store(in: &cancellables)
        viewModel.$isNoMoreData
            .sink { [weak self] bool in
                self?.isNoMoreData = bool
            }
            .store(in: &cancellables)
    }

    private func setUpView() {
        view.backgroundColor = .white
        view.addSubview(gyroDataTableView)
        view.addSubview(loadingIndicatorView)
      
        setUpGyroDataTableView()
        setUpLoadingIndicatorView()
    }
    
    private func setUpGyroDataTableView() {
        let safeArea = view.safeAreaLayoutGuide
        gyroDataTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gyroDataTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            gyroDataTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            gyroDataTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            gyroDataTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setUpLoadingIndicatorView() {
        let safeArea = view.safeAreaLayoutGuide
        loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicatorView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            loadingIndicatorView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            loadingIndicatorView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.4),
            loadingIndicatorView.heightAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.4)
        ])
    }
    
    private func setUpNavigationBar() {
        let title = "목록"
        let measurement = "측정"
        let rightButtonItem = UIBarButtonItem(title: measurement,
                                              style: .plain,
                                              target: self, action: #selector(measurementButtonTapped))
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationItem.title = title
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    @objc private func measurementButtonTapped() {
        let measureGyroDataViewController = MeasureGyroDataViewController(viewModel: measureViewModel)
        navigationController?.pushViewController(measureGyroDataViewController, animated: true)
    }
}

// MARK: DiffableDataSource
extension GyroDataListViewController {
    private func configureGyroDataTableView() {
        dataSource = UITableViewDiffableDataSource<Section, GyroEntity>(tableView: gyroDataTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GyroDataTableViewCell.identifier, for: indexPath) as? GyroDataTableViewCell else { return UITableViewCell() }
            
            cell.configureCell(with: itemIdentifier)
            return cell
        })
    }
    
    private func createSnapshot(_ data: [GyroEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, GyroEntity>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: UITableViewDelegate
extension GyroDataListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let gyroEntity = dataSource?.itemIdentifier(for: indexPath),
              let id = gyroEntity.id else { return nil }
        
        let play = "Play"
        let playAction = UIContextualAction(style: .normal, title: play) { [weak self] _, _, completion in
            guard let self = self else { return }
            
            let data = self.viewModel.read(at: indexPath)
            let detailViewController = DetailViewController(pageType: .play, viewModel: self.detailViewModel)
            
            self.detailViewModel.addData(data)
            navigationController?.pushViewController(detailViewController, animated: true)
            completion(true)
        }
        playAction.backgroundColor = .systemGreen
        
        let delete = "Delete"
        let deleteAction = UIContextualAction(style: .normal, title: delete) { [weak self] _, _, completion in
            self?.viewModel.delete(by: id)
            completion(true)
        }
        deleteAction.backgroundColor = .red

        let configuration = UISwipeActionsConfiguration(actions: [playAction, deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.read(at: indexPath)
        let detailViewController = DetailViewController(pageType: .view, viewModel: detailViewModel)
        
        detailViewModel.addData(data)
        navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if gyroDataTableView.contentOffset.y > (gyroDataTableView.contentSize.height - gyroDataTableView.bounds.size.height) {
            if !isNoMoreData && !isPaging {
                requestMorePage()
            }
        }
    }
    
    private func requestMorePage() {
        isPaging = true
        configureLoadingStatus()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.viewModel.readAll()
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
