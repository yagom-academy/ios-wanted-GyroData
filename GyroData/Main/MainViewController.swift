//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    //코어데이터 사용예정
    var datasource1 = [Measure]()
    let test = Measure(title: "test", second: 0.32)
    let test2 = Measure(title: "haha", second: 0.9999)
    let manager = CoreDataManager.shared
    
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
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    private func setupView() {
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    //실행시 기존데이터 로드
    private func loadData() {
  
        tableView.reloadData()
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
        //        두번째 뷰컨트롤러에서 데이터 받아오기
//        manager.insertMeasure(measure: test)
//        manager.insertMeasure(measure: test2)
//        manager.fetch()
        //        datasource = CoreDataManager.shared.getCoreData()
//        print(self.manager.count())
        tableView.reloadData()
        //
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.fetch().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier) as? CustomTableViewCell ?? CustomTableViewCell()
        cell.bind1(model: manager.fetch()[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    //SwipeAction
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let playAction = UIContextualAction(style: .normal, title:"Play"){ (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("paly 클릭 됨")
            //3번쨰 뷰컨틀롤러 이동과 동시에 데이터 업로드 예정
            let ReplayViewController = ReplayViewController()
            self.navigationController?.pushViewController(ReplayViewController, animated: true)
            //업데이트인가??
            self.manager.fetch()[indexPath.row]
            print(self.manager.count(), self.manager.fetch()[indexPath.row].id)
            success(true)
        }
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("delete 클릭 됨")
            // 코어데이터 제거
            self.manager.delete(object: self.manager.fetch()[indexPath.row])
            print(self.manager.count())
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
    }
}



