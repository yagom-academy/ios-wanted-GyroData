//
//  ListViewController.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/01/30.
//

import UIKit

struct SampleData {
    static let data = [Measurement(sensor: .Gyro, date: Date(),
                                   time: 25.5331, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Gyro, date: Date(),
                                   time: 11.5222, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Accelerometer, date: Date(),
                                   time: 12.2253, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Gyro, date: Date(),
                                   time: 60.0224, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Accelerometer, date: Date(),
                                   time: 211.5335, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Gyro, date: Date(),
                                   time: 50.323234, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Accelerometer, date: Date(),
                                   time: 225.5333, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Gyro, date: Date(),
                                   time: 235.53223, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Gyro, date: Date(),
                                   time: 141.522, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Accelerometer, date: Date(),
                                   time: 152.225, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Gyro, date: Date(),
                                   time: 610.022, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Accelerometer, date: Date(),
                                   time: 211.2533, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Gyro, date: Date(),
                                   time: 50.32323, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Accelerometer, date: Date(),
                                   time: 25.45333, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Gyro, date: Date(),
                                   time: 25.533, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Gyro, date: Date(),
                                   time: 11.6522, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Accelerometer, date: Date(),
                                   time: 12.7225, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Gyro, date: Date(),
                                   time: 60.8022, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Accelerometer, date: Date(),
                                   time: 211.9533, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Gyro, date: Date(),
                                   time: 50.032323, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Accelerometer, date: Date(),
                                   time: 25.125333, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Gyro, date: Date(),
                                   time: 25.34533, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Gyro, date: Date(),
                                   time: 11.55622, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Accelerometer, date: Date(),
                                   time: 12.27825, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Gyro, date: Date(),
                                   time: 60.09022, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Accelerometer, date: Date(),
                                   time: 211.51233, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Gyro, date: Date(),
                                   time: 50.3122323, value: [AxisValue(x: 10, y: 10, z: 10)]),
                       Measurement(sensor: .Accelerometer, date: Date(),
                                   time: 25.512333, value: [AxisValue(x: 10, y: 10, z: 10)]),

    ]
}

final class ListViewController: UIViewController {
    
    private typealias DataSource = UITableViewDiffableDataSource<Section, Measurement>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Measurement>
    
    private let measurements: [Measurement] = SampleData.data
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
        return UIAction { _ in
            print("Measurement Page 이동")
            // 구현 예정
        }
    }
}

extension ListViewController {
    private enum Section {
        case main
    }
}
