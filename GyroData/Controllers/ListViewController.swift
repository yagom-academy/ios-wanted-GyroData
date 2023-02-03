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
        registerListCell()
        configureDataSource()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialFetchMeasurementData()
        applySnapshot()
    }
    
    private func initialFetchMeasurementData() {
        coreDataManager.changeFetchOffset(isInitialFetch: true)
        
        switch coreDataManager.fetchData() {
        case .success(let fetchedMeasurements):
            measurements = fetchedMeasurements
        case .failure(let dataHandlerError):
            print(dataHandlerError.description)
            UIAlertController.show(title: "Error", message: "데이터 로딩에 실패했습니다", target: self)
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
        let playAction = UIContextualAction(style: .normal, title: "Play") { [weak self] _, _, _ in
            guard let self = self else { return }
            let reviewPageViewController = ReviewPageViewController(
                reviewPageView: ReviewPageView(pageState: .resultPlay),
                measurement: self.measurements[indexPath.item])
            
            self.navigationController?.pushViewController(reviewPageViewController, animated: false)
        }
        
        playAction.backgroundColor = .systemGreen
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            [weak self] _, _, _ in
            guard let self = self else { return }
            
            do {
                try self.dataManagers.forEach { dataManager in
                    try dataManager.deleteData(self.measurements[indexPath.item])
                }
                
                self.measurements.remove(at: indexPath.item)
                self.applySnapshot()
            }
            catch {
                print(DataHandleError.deleteFailError(error: error))
                UIAlertController.show(title: "Error",
                                       message: "데이터 삭제에 실패했습니다.",
                                       target: self)
            }
            
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, playAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        
        let reviewPageViewController = ReviewPageViewController(
            reviewPageView: ReviewPageView(pageState: .resultView),
            measurement: measurements[indexPath.item])
        
        self.navigationController?.pushViewController(reviewPageViewController, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isPaging && isScrollOnLastCell(scrollView) else { return }
        
        isPaging = true
        coreDataManager.changeFetchOffset(isInitialFetch: false)
        self.listView.tableView.tableFooterView = generateSpinnerFooter()
        
        switch coreDataManager.fetchData() {
        case .success(let fetchedMeasurements):
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.measurements += fetchedMeasurements
                self?.listView.tableView.tableFooterView = nil
                self?.applySnapshot()
                self?.isPaging = false
            }
        case .failure(let dataHandlerError):
            print(dataHandlerError.description)
            UIAlertController.show(title: "Error", message: "데이터 로딩에 실패했습니다", target: self)
        }
    }
    
    private func isScrollOnLastCell(_ scrollView: UIScrollView) -> Bool {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        return offsetY > contentHeight - frameHeight && contentHeight > frameHeight
    }
    
    private func generateSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: .zero, y: .zero,
                                              width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
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
