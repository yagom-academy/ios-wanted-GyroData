//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    var datasource = [GyroModel]()
    let manager = CoreDataManager.shared
    let FileManager = MeasureFileManager.shared
    var count = 0
    var dataCOunt = 0
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
        addNaviBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        tableView.reloadData()
        //        manager.fetch()
        //        datasource.append(contentsOf: manager.fetchTen1(offset: datasource.count))
        
        //                manager.fetchTen(offset: datasource.count)
        loadData()
        //        tableView.reloadData()
    }
    private func setupView() {
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //네비바 추가
    private func addNaviBar() {
        title = "목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정",style: .plain,target: self, action: #selector(measureButton))
    }
    
    //측정버튼액션
    @objc func measureButton(_ sender: UIBarButtonItem) {
        print("측정버튼")
        let MeasureView = MeasureViewController()
        self.navigationController?.pushViewController(MeasureView, animated: true)
        tableView.reloadData()
    }
    //실행시 기존데이터 로드
    private func loadData() {
        let data = manager.fetchTen(offset: datasource.count)
        datasource.append(contentsOf: data)
        dataCOunt = data.count
    }
}


extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //테이블셀이 10개일때 데이터를 10개불러오는곳??
        if datasource.count != count {
            count += dataCOunt
        }
        guard indexPath.row == count - 1 else {return}
        loadData()
        if datasource.count != count  {
            tableView.reloadData()
        }
        print("가드문안의내용indexPath: \(indexPath.row) datasource.count: \(datasource.count)")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
        //           manager.fetchTen(count: count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier) as? CustomTableViewCell ?? CustomTableViewCell()
        cell.bind1(model: datasource[indexPath.row])
        //manager.fetchTen(count: count)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    //SwipeAction
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let playAction = UIContextualAction(style: .normal, title:"Play"){ (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("paly 클릭 됨")
            
            let ReplayViewController = ReplayViewController()
            self.navigationController?.pushViewController(ReplayViewController, animated: true)
            //self.datasource[indexPath.row]
            //print(self.manager.count()!, self.datasource[indexPath.row].id!)
            success(true)
        }
        // 코어데이터 제거
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("delete 클릭 됨")
            self.manager.delete(object: self.datasource[indexPath.row])
            self.datasource.remove(at: indexPath.row)
            tableView.reloadData()
            success(true)
        }
        playAction.backgroundColor = .systemGreen
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction, playAction])
    }
}

//테이블뷰셀 선택시 3번째뷰컨트롤러뷰타입으로
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ReplayViewController = ReplayViewController()
        self.navigationController?.pushViewController(ReplayViewController, animated: true)
        print(datasource[indexPath.row].id!)
    }
}
