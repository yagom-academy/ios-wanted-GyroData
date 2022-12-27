//
//  MotionDataListViewController.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/27.
//

import UIKit

final class MotionDataListViewController: UIViewController {
    private lazy var recordTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RecordTableViewCell.self, forCellReuseIdentifier: RecordTableViewCell.reuseIdentifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layout()
        setUpNavigationBar()
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

    }
}

extension MotionDataListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: RecordTableViewCell.reuseIdentifier) as? RecordTableViewCell else {
            return UITableViewCell()
        }

        cell.setUpContents(motionRecord: MotionRecord(
            id: UUID(),
            startDate: Date(),
            msInterval: 10,
            motionMode: .accelerometer,
            coordinates: [Coordiante(x: 1, y: 1, z: 1),
                          Coordiante(x: 1, y: 1, z: 1),
                          Coordiante(x: 1, y: 1, z: 1)]))
        return cell
    }
}

extension MotionDataListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let playAction = UIContextualAction(style: .normal, title: "Play") { action, view, didSuccessed in
            didSuccessed(true)
        }

        playAction.backgroundColor = .systemGreen

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, didSuccessed in
            didSuccessed(true)
        }
        deleteAction.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [deleteAction, playAction])
    }
}
