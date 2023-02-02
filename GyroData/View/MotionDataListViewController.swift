//
//  MotionDataListViewController.swift
//  GyroData
//
//  Created by junho lee on 2023/01/31.
//

import UIKit

class MotionDataListViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let viewModel = MotionDataListViewModel()
    private var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
        configureNavigationItem()
        configureHierarchy()
        bindToViewModel()
        viewModel.action(.fetchData)
    }

    private func configureTableView() {
        tableView.register(
            MotionDataListTableViewCell.self,
            forCellReuseIdentifier: MotionDataListTableViewCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func configureNavigationItem() {
        navigationItem.title = "목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "측정",
            style: .plain,
            target: self,
            action: #selector(didPressRecordButton)
        )
    }

    private func configureHierarchy() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func bindToViewModel() {
        viewModel.bind(onUpdate: { [weak self] in
            DispatchQueue.main.async {
                self?.reloadTableViewData()
            }
        })
        viewModel.bind(onError: { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(title: errorMessage)
            }
        })
    }

    private func reloadTableViewData() {
        tableView.reloadData()
    }

    private func showAlert(title: String) {
        let alertController = UIAlertController(
            title: title,
            message: .none,
            preferredStyle: .alert
        )
        let okayAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
    }
}

extension MotionDataListViewController {
    @objc
    private func didPressRecordButton(_ sender: UIBarButtonItem) {
        viewModel.action(.record(handler: { [weak self] recordMotionDataViewModel in
            let viewController = RecordMotionDataViewController()
            self?.navigationController?.pushViewController(viewController, animated: true)
        }))
    }
}

extension MotionDataListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MotionDataListTableViewCell.identifier, for: indexPath
        ) as? MotionDataListTableViewCell else { return MotionDataListTableViewCell() }
        viewModel.configureCell(for: indexPath) { createdAt, type, length in
            cell.configureSubviewsText(createdAt: createdAt, type: type, length: length)
        }
        return cell
    }
}

extension MotionDataListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.action(.view(at: indexPath, handler: { [weak self] motionDataDetailViewModel in
            let viewController = MotionDataDetailViewController(viewModel: motionDataDetailViewModel)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }))
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfData() - 1, isLoading == false {
            isLoading = true
            viewModel.action(.fetchData)
            isLoading = false
        }
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let swipeActionsConfiguration = UISwipeActionsConfiguration(
            actions: [makeDeleteContextualAction(indexPath), makePlayContextualAction(indexPath)]
        )
        return swipeActionsConfiguration
    }

    private func makePlayContextualAction(_ indexPath: IndexPath) -> UIContextualAction {
        let title = "Play"
        return UIContextualAction(style: .normal, title: title) { [weak self] _, _, completion in
            self?.viewModel.action(.play(at: indexPath, handler: { motionDataDetailViewModel in
                let viewController = MotionDataDetailViewController(viewModel: motionDataDetailViewModel)
                self?.navigationController?.pushViewController(viewController, animated: true)
                completion(true)
            }))
        }
    }

    private func makeDeleteContextualAction(_ indexPath: IndexPath) -> UIContextualAction {
        let title = "Delete"
        return UIContextualAction(style: .destructive, title: title) { [weak self] _, _, completion in
            self?.viewModel.action(.delete(at: indexPath))
            completion(true)
        }
    }
}
