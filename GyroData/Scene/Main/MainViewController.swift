//
//  MainViewController.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/09/16.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: Properties
    
    private let listTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            MainTableViewCell.self,
            forCellReuseIdentifier: MainTableViewCell.identifier
        )
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    // MARK: - Methods
    
    private func commonInit() {
        setupBackgroundColor(.systemBackground)
        setupNavigationBar()
        setupSubView()
        setupConstraint()
        setupTableView()
    }
    
    private func setupBackgroundColor(_ color: UIColor?) {
        view.backgroundColor = color
    }
    
    private func setupNavigationBar() {
        setupNavigationBarTitle()
        setupNavigationBackButton()
    }
    
    private func setupNavigationBarTitle() {
        navigationItem.title = "목록"
        
        let attribute = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)
        ]
        navigationController?.navigationBar.titleTextAttributes = attribute
    }
    
    private func setupNavigationBackButton() {
        let rightBarButton = UIBarButtonItem(
            title: "측정",
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTapped)
        )
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupSubView() {
        view.addSubview(listTableView)
    }
    
    private func setupConstraint() {
        setupTableViewConstraint()
    }
    
    private func setupTableViewConstraint() {
        NSLayoutConstraint.activate([
            listTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            listTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            listTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            listTableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }
    
    private func setupTableView() {
        listTableView.dataSource = self
        listTableView.delegate = self
    }
    
    @objc private func rightBarButtonTapped() {
        let measurementEnrollController = MeasurementEnrollController()
        navigationController?.pushViewController(
            measurementEnrollController,
            animated: true
        )
    }
}

// MARK: Extension

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 20
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = MainTableViewCell()
        cell.setupTimeLabelText("2022/09/07 15:01:05")
        cell.setupTypeLabelText("Aaccelometer")
        cell.setupTypeMeasurementLabelText("100")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let measurementReplayViewController = MeasurementReplayViewController(
            with: .view
        )
        navigationController?.pushViewController(
            measurementReplayViewController,
            animated: true
        )
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let playButton = UIContextualAction(
            style: .normal,
            title: nil
        ) { [weak self] action, _, result in
            let measurementReplayViewController = MeasurementReplayViewController(
                with: .play
            )
            
            self?.navigationController?.pushViewController(
                measurementReplayViewController,
                animated: true
            )
            result(true)
        }
        
        playButton.makeCustomTitle(
            text: "Play",
            font: .systemFont(ofSize: 24, weight: .semibold),
            textColor: .white,
            backgroundColor: UIColor(named: "PlayColor")
        )
        
        let deleteButton = UIContextualAction(
            style: .destructive,
            title: nil
        ) { [weak self] _, _, result in
            print("Delete")
            result(true)
        }
        
        deleteButton.makeCustomTitle(
            text: "Delete",
            font: .systemFont(ofSize: 24, weight: .semibold),
            textColor: .white,
            backgroundColor: UIColor(named: "DeleteColor")
        )
        
        return UISwipeActionsConfiguration(actions:[deleteButton, playButton])
    }
}
