//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let viewModel = ViewModel()
    
    private let itemTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MainCell.self, forCellReuseIdentifier: MainCell.cellID)
        tableView.backgroundColor = .white
        return tableView
    }()
    private lazy var measureButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "측정", style: .plain, target: self, action: #selector(pushMeasureVC(_:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "목록"
        self.navigationItem.rightBarButtonItem = self.measureButton
        itemTableView.dataSource = self
        setTableViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        itemTableView.reloadData()
    }
    
    @objc private func pushMeasureVC(_ sender: Any) {
        self.navigationController?.pushViewController(MeasureViewController(), animated: true)
    }
    
    private func setTableViewLayout() {
        view.addSubview(itemTableView)
        
        NSLayoutConstraint.activate([
            itemTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            itemTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.gyroList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainCell.cellID, for: indexPath) as? MainCell else { return UITableViewCell() }
        cell.configureCell(gyroItem: viewModel.gyroList[indexPath.row])
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(DetailViewController(), animated: true)
    }
}
