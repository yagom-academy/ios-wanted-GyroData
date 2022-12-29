//
//  ListView.swift
//  GyroData
//
//  Created by brad on 2022/12/26.
//

import UIKit

final class ListView: UIView {
    var tableView = UITableView()
    
    init() {
        super.init(frame: .zero)
        addSubViews()
        setLayout()
        tableViewSetting()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func tableViewSetting() {
        tableView.register(ListViewCell.self, forCellReuseIdentifier: ListViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

private extension ListView {
    
    func addSubViews() {
        self.addSubview(tableView)
    }
    
    func setLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
