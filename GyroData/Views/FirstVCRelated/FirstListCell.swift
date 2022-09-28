//
//  FirstListCell.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import UIKit

class FirstListCell: UITableViewCell {

    lazy var cellView: FirstCellContentView = FirstCellContentView()
    var viewModel: FirstCellContentViewModel? {
        didSet {
            guard let viewModel else { return }
            cellView.didReceiveViewModel(viewModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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

extension FirstListCell: Presentable {
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
    
    func configureCell(viewModel: FirstCellContentViewModel) {
        self.viewModel = viewModel
    }
}
