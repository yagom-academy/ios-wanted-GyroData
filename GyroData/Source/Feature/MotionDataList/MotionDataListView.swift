//
//  MotionDataListView.swift
//  GyroData
//
//  Created by 권준상 on 2022/09/27.
//

import UIKit

class MotionDataListView: UIView {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MotionDataListTableViewCell.self, forCellReuseIdentifier: MotionDataListTableViewCell.identifier)
        tableView.rowHeight = 90
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        self.addSubview(tableView)
    }
    
    func setConstraints() {
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
