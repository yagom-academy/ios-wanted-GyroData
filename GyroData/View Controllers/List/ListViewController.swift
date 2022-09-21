//
//  ListViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit
import CoreData

final class ListViewController: UIViewController {
    
    var container: NSPersistentContainer!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        return tableView
    }()

    private var gyroDataList: [GyroData] = []
    private var isLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        configureNavigation()
        configureLayout()
        loadMoreData()
    }

    private func configureNavigation() {
        navigationItem.title = "목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정", style: .plain, target: self, action: #selector(didTapMeasureButton))
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadMoreData() {
        if isLoading { return }
        isLoading = true
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            let pageSize = 10
            let newData = GyroDataRepository.shared.fetchData(firstIndex: self.gyroDataList.count, pageSize: pageSize)
            self.gyroDataList.append(contentsOf: newData)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.isLoading = false
            }
        }
    }

    @objc
    private func didTapMeasureButton() {
        // TODO: 두 번째 페이지로 이동
    }
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gyroDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        let gyroData = gyroDataList[indexPath.row]
        cell.dateLabel.text = gyroData.dateString
        cell.keyLabel.text = gyroData.type.rawValue
        cell.valueLabel.text = "\(gyroData.value)"
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == gyroDataList.count - 1 {
            loadMoreData()
        }
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: 세 번째 페이지를 view 타입으로 이동
        let viewController = UIViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let playAction = UIContextualAction(style: .normal, title: "Play") { action, view, handler in
            // TODO: 세 번째 페이지를 play 타입으로 이동
            print("touch Play Button")
        }
        playAction.backgroundColor = .systemGreen
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, handler in
            // TODO: 데이터를 삭제 (CoreData와 파일 모두 삭제할 것)
            print("touch Delete Button")
        }
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, playAction])
        return configuration
    }
}
