//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit
import CoreData

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
    private var measureDataList: [MeasureData] = []
    private var loadCount: Int = 0
    private var indexPage: Int = 0
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureUI()
        constraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMeasureDataList()
    }
}

// MARK: - ConfigureTableView
extension ListViewController {
    private func configureTableView() {
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
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
            self.vStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.vStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.vStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.vStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(layout)
    }
    
    private func tableViewConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = [
            self.tableView.widthAnchor.constraint(equalTo: self.vStackView.widthAnchor),
            self.tableView.heightAnchor.constraint(equalTo: self.vStackView.heightAnchor)
        ]
        
        NSLayoutConstraint.activate(layout)
    }
}
// MARK: - Action
extension ListViewController {
    @objc private func didTapMeasurementButton() {
        let measureVC = MeasureViewController()
        self.navigationController?.pushViewController(measureVC, animated: true)
    }
    
    private func scrollToBottom(indexPath: IndexPath) {
        if indexPath.row + 1 == self.measureDataList.count {
                print("load more")
                if !(loadCount % 2 == 0) {
                    indexPage += 1
                    print("index: \(indexPage)")
                }
                loadCount += 1
                print("loadCount: \(loadCount)")
            }
    }
}
// MARK: - DataBinding
extension ListViewController {
    func fetchMeasureDataList() {
        let request = MeasureData.fetchRequest()
        request.fetchLimit = 20
        request.fetchOffset = measureDataList.count
        
        do {
            let motionDataList = try CoreDataManager.shared.context.fetch(request)
            self.measureDataList += motionDataList
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }
}
// MARK: - TableView
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let play = UIContextualAction(style: .normal, title: "Play") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            let showVC = ShowViewController()
            showVC.viewType = .replay
            showVC.setMeasureData(data: self.measureDataList[indexPath.row])
            
            self.navigationController?.pushViewController(showVC, animated: true)
        }
        play.backgroundColor = .systemGreen
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("delete 클릭 됨")
        }
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions:[delete, play])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let showVC = ShowViewController()
        showVC.viewType = .preview
        showVC.setMeasureData(data: self.measureDataList[indexPath.row])
        
        self.navigationController?.pushViewController(showVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        scrollToBottom(indexPath: indexPath)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return measureDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.cellId, for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        
        cell.timeLabel.text = measureDataList[indexPath.row].measureDate
        cell.typeLabel.text = measureDataList[indexPath.row].sensorType
        cell.valueLabel.text = measureDataList[indexPath.row].measureTime
        
        return cell
    }
}

