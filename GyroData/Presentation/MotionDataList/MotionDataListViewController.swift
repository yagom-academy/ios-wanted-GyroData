//
//  MotionDataListViewController.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/27.
//

import UIKit

final class MotionDataListViewController: UIViewController {
    private let viewModel = MotionDataListViewModel()

    private lazy var recordTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RecordTableViewCell.self, forCellReuseIdentifier: RecordTableViewCell.reuseIdentifier)
        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpViewModel()
        layout()
        setUpNavigationBar()
    }

    private func setUpViewModel() {
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.recordTableView.reloadData()
            }
        }
    }

    private func layout() {
        view.addSubview(recordTableView)
        NSLayoutConstraint.activate([
            recordTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recordTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recordTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recordTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setUpNavigationBar() {
        navigationItem.title = "목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정", style: .plain,
                                                            target: self,action: #selector(measureButtonTapped(_:)))
    }

    @objc
    private func measureButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(MotionRecordingViewController(), animated: true)
    }
}

extension MotionDataListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.records.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: RecordTableViewCell.reuseIdentifier) as? RecordTableViewCell else {
            return UITableViewCell()
        }

        cell.setUpContents(motionRecord: viewModel.records[indexPath.row])
        return cell
    }
}

extension MotionDataListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let playAction = UIContextualAction(style: .normal, title: "Play") { [weak self] _, _, _ in
            guard let self = self else { return }
            self.navigationController?.pushViewController(
                MotionReplayViewController(replayType: .play, motionRecord: self.viewModel.records[indexPath.row])
                , animated: true
            )
        }
        playAction.backgroundColor = .systemGreen

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.viewModel.deleteCellSwipeActionDone(indexPath: indexPath) {
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
        deleteAction.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [deleteAction, playAction])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(
            MotionReplayViewController(replayType: .view, motionRecord: viewModel.records[indexPath.row])
            , animated: true
        )
    }
}
