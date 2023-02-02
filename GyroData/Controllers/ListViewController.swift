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
    
    private var measurements: [Measurement] = []
    private let listView: ListView = ListView()
    private var dataSource: DataSource? = nil
    private var snapShot: SnapShot = SnapShot()
    private var isPaging: Bool = false
    private let coreDataManager = CoreDataManager()
    private let sensorFileManager = SensorFileManager()
    lazy var dataManagers: [any MeasurementDataHandleable] = [coreDataManager, sensorFileManager]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawView()
        initialFetchMeasurementData()
        registerListCell()
        configureDataSource()
        applySnapshot()
        setupNavigationBar()
    }
    
    private func initialFetchMeasurementData() {
        switch coreDataManager.fetchData() {
        case .success(let fetchedMeasurements):
            measurements = fetchedMeasurements
        case .failure(let dataHandlerError):
            print(dataHandlerError.description)
            // Alert 처리
        }
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
            let reviewPageViewController = ReviewPageViewController(
                reviewPageView: ReviewPageView(pageState: .resultPlay))
            
            self.navigationController?.pushViewController(reviewPageViewController, animated: false)
        }
        
        playAction.backgroundColor = .systemGreen
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            [weak self] _, _, _ in
            guard let self = self else { return }
            self.dataManagers.forEach { dataManager in
                do {
                    try dataManager.deleteData(self.measurements[indexPath.item])
                }
                catch {
                    print(DataHandleError.deleteFailError(error: error))
                    //알럿처리
                }
            }
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, playAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        presentDetailPage()
    }
    
    private func presentDetailPage() {
        let reviewPageViewController = ReviewPageViewController(
            reviewPageView: ReviewPageView(pageState: .resultView))
        
        self.navigationController?.pushViewController(reviewPageViewController, animated: false)
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
            guard let self = self else { return }
            let measureViewController = MeasurementViewController(dataManagers: self.dataManagers)
            self.navigationController?.pushViewController(measureViewController, animated: false)
        }
    }
}

extension ListViewController {
    private enum Section {
        case main
    }
}
