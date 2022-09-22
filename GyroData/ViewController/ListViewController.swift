//
//  ListViewController.swift
//  GyroData
//
//  Created by 유영훈 on 2022/09/20.
//

import UIKit
import CoreData

//struct TestCell {
//    let liftName :String
//    let rightName: String
//    let centers: String
//}
//

class ListViewController: UIViewController {
    //연산프로퍼티 검색100%, 함수 호출
    //델리게이트 패턴, 할리우드 원칙(이론)
    private var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
//    var dataSource = [TestCell]()
//    let testCell: [TestCell] = [TestCell.init(liftName: "1", rightName: "2", centers: "3")]
    var container: NSPersistentContainer!
    var runDataList: [RunDataList] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //호출해라고 시킨적없는데 왜 호출되냐 뷰컨에 호출한다 애플이숨겼다 애플과의계약?
        let appDelegata = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegata.persistentContainer
        view.backgroundColor = .white
        layout()
        addNaviBar()
        addSetuo()
        
        
    }
    func addSetuo() {
        let list = ["Accelerometer", "Gyro", "Accelerometer1"]
        for i in list {
            self.runDataList.append(RunDataList(timestamp: "yy:mm", gyro: "측정값", interval: 43.44))
        }
    }
    
    
    
    func layout() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
//    private func loadData() {
//        runDataList.append(.init(timestamp: "timestemp", gyro: "gyro", interval: 43.6))
//        tableView.reloadData()
//    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //스왑 버튼
        let actions1 = UIContextualAction(style: .normal, title: "Delete", handler: { action, view, completionHaldler in
            completionHaldler(true)
        })
        actions1.backgroundColor = .systemRed
        //스왑버튼
        let actions2 = UIContextualAction(style: .normal, title: "Play", handler: { action, view, completionHaldler in
            completionHaldler(true)
        })
        actions2.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [actions1, actions2])
    }
    
    private func addNaviBar() {
        title = "목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정", style: .plain, target: self, action: #selector(add))
    }
    @objc func add(_ sender: Any) {
        let secondView = ReplayViewController()     // 3번째 화면 푸시
        self.navigationController?.pushViewController(secondView, animated: true)
    }
}


extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runDataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCell
        let list = runDataList[indexPath.row]
        cell.leftLabel.text = list.timestamp
        cell.rightLabel.text = "\(list.interval)"
        cell.centerLabel.text = list.gyro
        
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }
}
