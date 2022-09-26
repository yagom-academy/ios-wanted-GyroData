//
//  FirstListLoadingCell.swift
//  GyroData
//
//  Created by channy on 2022/09/26.
//

import UIKit

class FirstListLoadingCell: UITableViewCell {

    lazy var cellView: FirstLoadingCellContentView = FirstLoadingCellContentView()
    var viewModel: FirstLoadingCellContentViewModel? {
        didSet {
            guard let viewModel else { return }
            cellView.didReceiveViewModel(viewModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViewHierarchy()
        configureView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FirstListLoadingCell: Presentable {
    func initViewHierarchy() {
        self.contentView.addSubview(cellView)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraints) }
        
        constraints += [
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
    }
    
    func configureView() {
        self.selectionStyle = .none
    }
    
    func bind() {
        
    }
    
    func configureCell(viewModel: FirstLoadingCellContentViewModel) {
        self.viewModel = viewModel
    }
}
