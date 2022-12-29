//
//  AnalysisTableViewCell.swift
//  GyroData
//
//  Created by unchain, Ellen J, yeton on 2022/12/28.
//

import UIKit

final class AnalysisTableViewCell: UITableViewCell {
    static let identifier = "AnalysisCell"

    let savedAtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let analysisTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let measurementTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 10
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        setConstraints()
        self.backgroundColor = UIColor(r: 39, g: 40, b: 46, a: 1)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func addSubViews() {
        informationStackView.addArrangedSubview(savedAtLabel)
        informationStackView.addArrangedSubview(analysisTypeLabel)

        self.contentView.addSubview(informationStackView)
        self.contentView.addSubview(measurementTimeLabel)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            informationStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 30),
            informationStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            informationStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),

            measurementTimeLabel.leadingAnchor.constraint(equalTo: informationStackView.trailingAnchor),
            measurementTimeLabel.topAnchor.constraint(equalTo: informationStackView.topAnchor),
            measurementTimeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -30),
            measurementTimeLabel.bottomAnchor.constraint(equalTo: informationStackView.bottomAnchor)
        ])
    }

    func configureCell(at indexPath: IndexPath, cellData: [CellModel]) {
        savedAtLabel.text = cellData[indexPath.row].savedAt.formattedString()
        measurementTimeLabel.text = String(cellData[indexPath.row].measurementTime)
        analysisTypeLabel.text = cellData[indexPath.row].analysisType
    }
}

extension Date {
    func formattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
}
