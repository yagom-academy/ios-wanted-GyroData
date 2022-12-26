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
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func tableViewSetting() {
        tableView.register(ListViewCell.self, forCellReuseIdentifier: ListViewCell.identifier)
    }
    
}

extension ListView {
    
    func addSubViews() {
        self.addSubview(tableView)
    }
    
    func setLayout() {
        
    }
}
