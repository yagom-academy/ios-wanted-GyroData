//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit


class GyroDataListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(GyroDataListTableViewCell.self, forCellReuseIdentifier: GyroDataListTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 90
        tableView.translatesAutoresizingMaskIntoConstraints = false

        self.title = "목록"
        self.view.backgroundColor = .white

        // 네비게이션 아이템 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정", style: .plain, target: self, action: #selector(goToMeasureDataVC))

    }

    //MeasureViewController 로 간다
    @objc fileprivate func goToMeasureDataVC(){
        let measureDataVC = MeasureDataViewController()
        self.navigationController?.pushViewController(measureDataVC, animated: true)
    }

    // tableView Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GyroDataListTableViewCell.identifier, for: indexPath) as? GyroDataListTableViewCell
        else { return UITableViewCell() }

        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modity = UIContextualAction(style: .normal, title: "Play") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("play")
            success(true)
        }
        modity.backgroundColor = .systemGreen
        
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("delete")
            success(true)
        }
        delete.backgroundColor = .systemRed
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions:[delete, modity])
        swipeActionConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeActionConfiguration
    }

}


