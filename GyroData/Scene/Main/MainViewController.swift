//
//  MainViewController.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/09/16.
//

import UIKit

final class MainViewController: UIViewController {
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
        view.backgroundColor = .systemBackground
        commonInit()
    }
    
    // MARK: - Methods
    
    private func commonInit() {
        setupNavigationBar()
        setupSubView()
        setupConstraint()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "목록"
        let attribute = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attribute as [
            NSAttributedString.Key : Any
        ]
        
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
        print("view move")
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 3
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
}
