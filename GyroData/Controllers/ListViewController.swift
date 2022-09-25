//
//  ViewController.swift
//  GyroExample
//
//  Created by KangMingyo on 2022/09/24.
//

import UIKit

class ListViewController: UIViewController {
    
    var datas = [Save]()
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "ko_kr")
        f.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return f
    }()
    //윌디스플레이스 에니매에 있다 10개씩 10개씩 부르는건 어펜드하면된다  10개 부르는건?
    lazy var navButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "측정", style: .plain, target: self, action: #selector(add))
        return button
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = self.navButton
        title = "목록"
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataManager.shared.fetchSave()
        tableView.reloadData()
    }
    
    @objc func add(_ sender: Any) {
        let secondView = MeasurmentViewController()     // 두번째 화면 푸시
        self.navigationController?.pushViewController(secondView, animated: true)
    }
    
    func configure() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableViewDelegate()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 100
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }

    func tableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {  //그려질려고할때 2번째 셀의 데이터가 있어  근데 아직 안그렸어 그다음을 안시킬려면 // //여기서 멈춘다 1개보이는데 2개를 보이게 하기 위해서 그래서
        if indexPath.row == DataManager.shared.saveList.count - 1 {
            DataManager.shared.fetchSave()
            tableView.reloadData()
        } // 5개 가있으니깐 5개가 더나오지  마지막셀은4
        // 마지셀은 카운트 -1 마지막이다  내가 5개로 정했지만 배열는 4번이니깐  10개면 9가 마지막  -1 이  75줄 이 같다면 마지막셀이다   // 뷰윌이라서 2개를 그릴려고 하기때문에 그렇다 
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.saveList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let target = DataManager.shared.saveList[indexPath.row]
        cell.dateLabel.text = formatter.string(for: target.date)
        cell.nameLabel.text = target.name
        cell.timeLabel.text = String(format: "%.1f", target.time)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondView = ReplayViewController()
        secondView.pageType = "View"
        secondView.data = DataManager.shared.saveList[indexPath.row]
        self.navigationController?.pushViewController(secondView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let actions1 = UIContextualAction(style: .normal, title: "Delete", handler: { action, view, completionHaldler in
            completionHaldler(true)
            let cell = DataManager.shared.saveList.remove(at: indexPath.row)
            DataManager.shared.deleteRun(object: cell)
            tableView.reloadData()
        })
        actions1.backgroundColor = .systemRed
    
        let actions2 = UIContextualAction(style: .normal, title: "Play", handler: { action, view, completionHaldler in
            completionHaldler(true)
            let secondView = ReplayViewController()
            secondView.pageType = "Play"
            secondView.data = DataManager.shared.saveList[indexPath.row]
            self.navigationController?.pushViewController(secondView, animated: true)
        })
        actions2.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [actions1, actions2])
    }


}
