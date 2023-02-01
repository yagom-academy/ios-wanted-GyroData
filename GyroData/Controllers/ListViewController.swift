//
//  ListViewController.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/01/30.
//

import UIKit

final class ListViewController: UIViewController {
    
    private typealias DataSource = UITableViewDiffableDataSource<Section, Measurement>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Measurement>
    
    private let measurements: [Measurement] = []
    private let listView: ListView = ListView()
    private var dataSource: DataSource? = nil
    private var snapShot: SnapShot = SnapShot()
    private var isPaging: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawView()
        registerListCell()
        configureDataSource()
        applySnapshot()
        setupNavigationBar()
    }
    
    private func drawView() {
        view = listView
        listView.tableView.delegate = self
    }
    
    private func registerListCell() {
        listView.tableView.register(ListCell.self,
                                    forCellReuseIdentifier: ListCell.reuseIdentifier)
    }
    
    private func configureDataSource() {
        let tableView = listView.tableView
        
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, measurement in
            let cellIdentifier = ListCell.reuseIdentifier
            
            let listCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            as? ListCell
            
            listCell?.setup(date: measurement.date.makeSlashFormat(),
                            sensorName: measurement.sensor.name,
                            value: String(format: "%.1f", measurement.time))
            
            return listCell
        }
    }
    
    private func applySnapshot() {
        snapShot.deleteAllItems()
        snapShot.appendSections([.main])
        snapShot.appendItems(measurements)
        dataSource?.apply(snapShot)
    }
}

//MARK: - TableViewDelegate
extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        let playAction = UIContextualAction(style: .normal, title: "Play") { _, _, _ in
            print("데이터 Play")
            // 액션 구현 예정
        }
        playAction.backgroundColor = .systemGreen
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  _, _, _ in
            print("Cell, Date 삭제")
            // 액션 구현 예정
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, playAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        presentDetailPage()
    }
    
    private func presentDetailPage() {
        //구현예정: 3번째 페이지연결
        print("자세히보기")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        guard isPaging == false,
              offsetY > contentHeight - frameHeight else {
            return
        }
        
        isPaging = true
        // 구현예정
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            print("paging")
        }
        isPaging = false
    }
}

//MARK: - NavigationBar
extension ListViewController {
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "목록"
        
        let measurementButton = UIBarButtonItem(title: "측정",
                                                image: nil,
                                                primaryAction: presentMeasurementPage(),
                                                menu: nil)
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = measurementButton
    }
    
    private func presentMeasurementPage() -> UIAction {
        return UIAction { [weak self] _ in
            self?.navigationController?.pushViewController(
                MeasurementViewController(dataManagers: [CoreDataManager(), SensorFileManager()]),
                animated: false)
        }
    }
}

extension ListViewController {
    private enum Section {
        case main
    }
}
