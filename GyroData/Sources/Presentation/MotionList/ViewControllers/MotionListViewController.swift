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
        tableView.backgroundColor = .white
        tableView.register(MotionDataCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
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
    
    private func contextualActions() -> [UIContextualAction] {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completeHandeler in
            print(#function)
            completeHandeler(true)
        }
        let playAction = UIContextualAction(style: .normal, title: nil) { _, _, completeHandeler in
            print(#function)
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
}

extension MotionListViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: contextualActions())
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showMotionDetailView()
    }
    
}
