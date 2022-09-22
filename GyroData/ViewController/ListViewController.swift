//
//  ListViewController.swift
//  GyroData
//
//  Created by 유영훈 on 2022/09/20.
//

import UIKit
import CoreData

struct TestCell {
    let liftName :String
    let rightName: String
    let centers: String
}


class ListViewController: UIViewController {
    
    private var tableView: UITableView {
        let tableView = UITableView()
        view.addSubview(tableView)
        return tableView
    }
    
    var dataSource = [TestCell]()
    
    let testCell: [TestCell] = [TestCell.init(liftName: "1", rightName: "2", centers: "3")]
    
    var window: UIWindow?
    var container: NSPersistentContainer!
    private var runDataList: [RunDataList] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegata = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegata.persistentContainer
        tableView.delegate = self
        tableView.dataSource = self
        
        layout()
        attridute()
        addNaviBar()
        setupView()
        loadData()

        
        
        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window?.windowScene = windowScene
            let navigationController = UINavigationController(rootViewController: ListViewController())
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible() //네비게이션 추가
        }
    }
    
  
    
    private func setupView() {
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func loadData() {
        dataSource.append(.init(liftName: "왼쪽?", rightName: "오른쪽", centers: "가운데"))
        
        tableView.reloadData()
    }
    
//    func addArray() {
//        for runtime in runDataList {
//            self.runDataList.append(RunDataList(uuid: 1, gyro: "2", acc: "3", timestamp: "4", interval: 1.1))
//        }
//    }
    
    
    func attridute() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func layout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
//    func setModel(model: CustomCell) {
//
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
        
        var statusBarHeight: CGFloat = 0
        statusBarHeight = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        // navigationBar
        let naviBar = UINavigationBar(frame: .init(x: 0, y: statusBarHeight, width: view.frame.width, height: statusBarHeight))
        naviBar.isTranslucent = false
        naviBar.backgroundColor = .systemBackground
        
        let naviItem = UINavigationItem(title: "목록")
        naviItem.rightBarButtonItem = UIBarButtonItem(title: "측정", style: .plain, target: self, action: #selector(add))
        // + 버튼
//        naviItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        naviBar.items = [naviItem]
            view.addSubview(naviBar)
    }
    @objc func add(_ sender: Any) {
        // 측정 클릭시 3번째 화면 이동하기
    }
}


extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell else { return UITableViewCell() }
        cell.centerLabel.text = testCell[indexPath.row].centers
        cell.rightLabel.text = testCell[indexPath.row].rightName
        cell.leftLabel.text = testCell[indexPath.row].liftName
//        cell.bind(model: dataSource[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
