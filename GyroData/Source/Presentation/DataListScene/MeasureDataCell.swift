//
//  MeasureDataCell.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/02/01.
//

import UIKit

final class MeasureDataCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MeasureDataCell {
    private func setupView() {
        
    }
    
    private func setupConstraint() {
        
    }
}

extension MeasureDataCell: Identifiable { }
