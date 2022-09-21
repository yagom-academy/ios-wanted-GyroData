//
//  ListViewController.swift
//  GyroData
//
//  Created by 유영훈 on 2022/09/20.
//

import UIKit
import CoreData

class ListViewController: UIViewController {
    
    let listTable = UITableView()
    let test = ["a", "b", "c", "d", "e", "f", "g"]
    var window: UIWindow?
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTable.delegate = self
        listTable.dataSource = self
        
        layout()
        attridute()
        addNaviBar()
        
//        let hemg = CoreData(uuid: 3, gyro: "g", acc: "y", timestamp: "d", interval: 1.1)

        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window?.windowScene = windowScene
            let navigationController = UINavigationController(rootViewController: ListViewController())
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible() //네비게이션 추가
        }
    }
    func attridute() {
        listTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    private let label: UILabel = {
        let label = UILabel()
        label.text = "ok?"
        label.textColor = UIColor.systemRed
        return label
    }()
    
    func layout() {
        view.addSubview(listTable)
        listTable.translatesAutoresizingMaskIntoConstraints = false
        listTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        listTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        listTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        listTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    @objc func add(_ sender: Any) {
        let alert = UIAlertController(title: "아직모름", message: nil, preferredStyle: .alert)
    }
    
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
    

    
}


extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return test.count
        return DataManager.shared.runList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        let target = DataManager.shared.runList[indexPath.row]
        cell.textLabel?.text = test[indexPath.row]
        return cell
    }
}
