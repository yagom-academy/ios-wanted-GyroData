//
//  ListView.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/01/30.
//

import UIKit

final class ListView: UIView {
    
    private(set) var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    init() {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        self.addSubview(tableView)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
