//
//  MainTableView.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/26.
//

import UIKit

final class MainTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupDefault()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDefault() {
        self.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.id)
        self.separatorStyle = .none
    }
}
