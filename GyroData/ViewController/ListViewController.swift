//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

struct Value {
    let time: String
    let type: String
    let value: String
}

class ListViewController: BaseViewController {
    // MARK: - View
    private lazy var measurementButton: UIButton = {
        let button = UIButton()
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.tintColor, for: .normal)
        button.addTarget(self, action: #selector(self.didTapMeasurementButton), for: .touchDown)
                
        return button
    }()
    
    private lazy var tableView: UITableView = {
            let view = UITableView()
            
            return view
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            measurementButton, tableView
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        
        return stackView
    }()
    // MARK: - Properties
    private let viewTitle: String = "목록"
    
    private let value: [Value] = [Value(time: "2022/09/08 14:50:43", type: "Acceleroment", value: "43.4"),
                                  Value(time: "2022/09/07 15:10:11", type: "Gyro", value: "60.0"),
                                  Value(time: "2022/09/06 09:33:30", type: "Acceleroment", value: "30.4")]
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        constraints()
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - ConfigureUI
extension ListViewController {
    private func configureUI() {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.title = self.viewTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: measurementButton)
    }
}

// MARK: - Constraint
extension ListViewController {
    private func constraints() {
        vStackViewConstraints()
        tableViewConstraints()
    }
    
    private func vStackViewConstraints() {
        self.view.addSubview(vStackView)
        self.vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = [
            self.vStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.vStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.vStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(layout)
    }

    private func tableViewConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false

        let layout = [
            self.tableView.widthAnchor.constraint(equalTo: self.vStackView.widthAnchor),
            self.tableView.heightAnchor.constraint(equalTo: self.vStackView.widthAnchor)
        ]

        NSLayoutConstraint.activate(layout)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.cellId, for: indexPath) as! CustomCell
        
        cell.timeLabel.text = value[indexPath.row].time
        cell.typeLabel.text = value[indexPath.row].type
        cell.valueLabel.text = value[indexPath.row].value
        
        return cell
    }
}

// MARK: - Action
extension ListViewController {
    @objc private func didTapMeasurementButton() {
        print("measurement")
    }
}
