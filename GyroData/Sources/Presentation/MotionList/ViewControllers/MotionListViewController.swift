//
//  MotionListViewController.swift
//  GyroData
//
//  Created by Ari on 2022/12/27.
//

import UIKit

class MotionListViewController: UIViewController {

    weak var coordinator: MotionListCoordinatorInterface?
    private let viewModel: MotionListViewModel
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 90
        tableView.backgroundColor = .systemBackground
        tableView.register(MotionDataCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    init(viewModel: MotionListViewModel, coordinator: MotionListCoordinatorInterface) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.motions.observe(on: self) { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    private func setUp() {
        setUpNavigationBar()
        setUpView()
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = "목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "측정",
            style: .plain,
            target: self,
            action: #selector(didTapMeasure(_:))
        )
    }
    
    @objc private func didTapMeasure(_ sender: UIBarButtonItem) {
        coordinator?.showMotionMeasureView()
    }
    
    private func setUpView() {
        view.addSubviews(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
}

extension MotionListViewController {
    
    private func contextualActions(
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> [UIContextualAction] {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completeHandeler in
            self?.viewModel.didDeleteAction(at: indexPath.row)
            completeHandeler(true)
        }
        let playAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completeHandeler in
            guard let motionEntity = self?.viewModel.motions.value[indexPath.row] else {
                return
            }
            self?.coordinator?.showMotionPlayView(motionEntity: motionEntity)
            completeHandeler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        playAction.image = UIImage(systemName: "play.fill")
        playAction.backgroundColor = .systemGreen
        return [deleteAction, playAction]
    }
    
}

extension MotionListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(MotionDataCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        cell.setUp(by: viewModel.motions.value[safe: indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.motions.value.count
    }
    
}

extension MotionListViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(
            actions: contextualActions(trailingSwipeActionsConfigurationForRowAt: indexPath)
        )
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let motionEntity = viewModel.motions.value[indexPath.row]
        coordinator?.showMotionDetailView(motionEntity: motionEntity)
    }
    
}

extension MotionListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let index = indexPaths.last?.row, index != viewModel.motions.value.count - 1 else {
            return
        }
        viewModel.prefetch()
    }
    
}
