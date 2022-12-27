//
//  RecordTableViewCell.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/27.
//

import UIKit

final class RecordTableViewCell: UITableViewCell {
    static let reuseIdentifier = "recordTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
