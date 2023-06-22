//
//  GyroDataTableViewCell.swift
//  GyroData
//
//  Created by 리지 on 2023/06/12.
//

import UIKit
import Combine

final class GyroDataTableViewCell: UITableViewCell {
    static let identifier = "GyroDataTableViewCell"
    
    private var viewModel: GyroDataTableCellViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 50
        
        return stackView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        
        return label
    }()
    
    private let sensorTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        
        return label
    }()
    
    private let recordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel?.$sixAxisData
            .map { $0.date }
            .sink { [weak self] date in
                self?.dateLabel.text = self?.viewModel?.date
            }
            .store(in: &cancellables)
        viewModel?.$sixAxisData
            .map { $0.title }
            .sink { [weak self] title in
                self?.sensorTypeLabel.text = self?.viewModel?.title
            }
            .store(in: &cancellables)
        viewModel?.$sixAxisData
            .map { $0.recordTime }
            .sink { [weak self] time in
                self?.recordLabel.text = self?.viewModel?.recordTitle
            }
            .store(in: &cancellables)
    }
   
    private func setUpUI() {
        self.backgroundColor = .white
        self.addSubview(horizontalStackView)
        setUpStackView()
    }
    
    private func setUpStackView() {
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(recordLabel)
        
        verticalStackView.addArrangedSubview(dateLabel)
        verticalStackView.addArrangedSubview(sensorTypeLabel)
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.widthAnchor.constraint(equalTo: horizontalStackView.widthAnchor, multiplier: 0.5),
            horizontalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            horizontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            horizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30)
        ])
    }
}

extension GyroDataTableViewCell {
    func configureCell(with data: GyroEntity) {
        viewModel = GyroDataTableCellViewModel(sixAxisData: data)
        bind()
    }
}
