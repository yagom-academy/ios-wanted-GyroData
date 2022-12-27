//
//  MotionListViewController.swift
//  GyroData
//
//  Created by 이호영 on 2022/12/27.
//

import UIKit

class MotionListViewController: UIViewController {

    private var motionListTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()
        configureNavigationBar()
    }

    private func setupView() {
        addSubViews()
        setupConstraints()
        view.backgroundColor = .systemBackground
    }
    
    func addSubViews() {
        view.addSubview(motionListTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            motionListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            motionListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            motionListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            motionListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupTableView() {
        motionListTableView.delegate = self
        motionListTableView.dataSource = self
        motionListTableView.register(
            MotionListTableViewCell.self,
            forCellReuseIdentifier: MotionListTableViewCell.cellIdentifier
        )
        motionListTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setCellTextColor (cell: UITableViewCell) {
        cell.backgroundColor = .white
        cell.textLabel?.textColor = .lightGray
        cell.detailTextLabel?.textColor = .lightGray
    }
}

extension MotionListViewController: UITableViewDelegate {
     
}

extension MotionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MotionListTableViewCell.cellIdentifier, for: indexPath) as? MotionListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(title: "Accelerometer", date: "2022/09/08 14:50:43", time: "43.4")
        return cell
    }
}

// MARK: NavigationController

extension MotionListViewController {
    private func configureNavigationBar() {
        let measurementBarButton = UIBarButtonItem(title: "측정",
                                            style: .done,
                                            target: self,
                                            action: #selector(measurementBarButtonTapped))

        navigationItem.rightBarButtonItem = measurementBarButton
        navigationItem.title = "목록"
    }

    @objc private func measurementBarButtonTapped() {
        let viewController = ViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

