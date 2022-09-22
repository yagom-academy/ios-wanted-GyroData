//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit
import SnapKit

struct CustomCellModel {
    let dataTypeLabel: String
    let valueLabel: String
    let dateLabel: String
}


class MainViewController: UIViewController {
    var dataSource = [CustomCellModel]()
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupView()
        loadData()
        addNaviBar()
        
    }
    
    private func setupView() {
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func loadData() {
        dataSource.append(.init(dataTypeLabel: "Accelerometer", valueLabel: "43.4",dateLabel: "yyyy:mm:dd"))
        dataSource.append(.init(dataTypeLabel: "Gyro", valueLabel: "60",dateLabel: "yyyy:mm:dd"))
        dataSource.append(.init(dataTypeLabel: "Accelerometer", valueLabel: "30.4",dateLabel: "yyyy:mm:dd"))
        dataSource.append(.init(dataTypeLabel: "Accelerometer", valueLabel: "22.3",dateLabel: "yyyy:mm:dd"))
        dataSource.append(.init(dataTypeLabel: "Gyro", valueLabel: "333.2",dateLabel: "yyyy:mm:dd"))
        dataSource.append(.init(dataTypeLabel: "Accelerometer", valueLabel: "43.4",dateLabel: "yyyy:mm:dd"))
        dataSource.append(.init(dataTypeLabel: "Gyro", valueLabel: "60",dateLabel: "yyyy:mm:dd"))
        dataSource.append(.init(dataTypeLabel: "Accelerometer", valueLabel: "30.4",dateLabel: "yyyy:mm:dd"))
        dataSource.append(.init(dataTypeLabel: "Accelerometer", valueLabel: "22.3",dateLabel: "yyyy:mm:dd"))
        dataSource.append(.init(dataTypeLabel: "Gyro", valueLabel: "333.2",dateLabel: "yyyy:mm:dd"))
        dataSource.append(.init(dataTypeLabel: "Accelerometer", valueLabel: "43.4",dateLabel: "yyyy:mm:dd"))
        dataSource.append(.init(dataTypeLabel: "Gyro", valueLabel: "60",dateLabel: "yyyy:mm:dd"))
        dataSource.append(.init(dataTypeLabel: "Accelerometer", valueLabel: "30.4",dateLabel: "yyyy:mm:dd"))
        dataSource.append(.init(dataTypeLabel: "Accelerometer", valueLabel: "22.3",dateLabel: "yyyy:mm:dd"))
        dataSource.append(.init(dataTypeLabel: "Gyro", valueLabel: "333.2",dateLabel: "yyyy:mm:dd"))
        
        tableView.reloadData()
    }
    
    private func addNaviBar() {
        title = "목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정",style: .plain,target: self, action: #selector(measureButton))
    }
    @objc func measureButton(_ sender: UIBarButtonItem) {
        print("측정버튼")
            let MeasureView = MeasureViewController()
        self.navigationController?.pushViewController(MeasureView, animated: true)
        }
    }


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier) as? CustomTableViewCell ?? CustomTableViewCell()
        cell.bind(model: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    //SwipeAction
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let playAction = UIContextualAction(style: .normal, title:"Play"){ (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("paly 클릭 됨")
            success(true)
        }
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("delete 클릭 됨")
            
            success(true)
        }
        
        playAction.backgroundColor = .systemGreen
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction, playAction])
    }
}



