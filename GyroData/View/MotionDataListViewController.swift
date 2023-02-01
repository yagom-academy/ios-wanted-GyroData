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

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureHierarchy()
        bindToViewModel()
        viewModel.fetchMotionData()
    }

    private func configureTableView() {
        tableView.register(
            MotionDataListTableViewCell.self,
            forCellReuseIdentifier: MotionDataListTableViewCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self
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
    }

    private func reloadTableViewData() {
        tableView.reloadData()
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
        guard let motionData = viewModel.motionData(at: indexPath) else { return cell }
        cell.configureSubviewsText(createdAt: motionData.createdAt.dateTimeString(),
                                   type: motionData.motionDataType.rawValue,
                                   length: motionData.length.description)
        return cell
    }
}

extension MotionDataListViewController: UITableViewDelegate {
}
