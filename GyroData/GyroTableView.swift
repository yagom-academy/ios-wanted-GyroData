//
//  GyroTableView.swift
//  GyroData
//
//  Created by 이은찬 on 2022/12/26.
//

import UIKit

final class GyroTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupDefault()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDefault() {
        self.register(GyroTableViewCell.self, forCellReuseIdentifier: GyroTableViewCell.id)
        self.separatorStyle = .none
    }
}
