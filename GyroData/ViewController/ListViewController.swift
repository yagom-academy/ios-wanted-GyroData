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
        let tableView = UITableView()
        tableView.rowHeight = 90
        
        return tableView
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
    private var fetchOffset: Int = 0
    private var isLoadData: Bool = false
    
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
    
    private func readMoreData() {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .systemBlue
        indicator.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        if !self.isLoadData {
            self.isLoadData = true
            self.tableView.tableFooterView = indicator
            indicator.startAnimating()
            DispatchQueue.global().async { [weak self] in
                self?.fetchMeasureDataList()
            }
        }
    }
}
// MARK: - DataBinding
extension ListViewController {
    func fetchMeasureDataList() {
        let request = MeasureData.fetchRequest()
        request.fetchLimit = 10
        request.fetchOffset = self.fetchOffset
        
        do {
            let nextData = try CoreDataManager.shared.context.fetch(request)
            if !nextData.isEmpty {
                self.measureDataList += nextData
                self.fetchOffset += nextData.count
                DispatchQueue.main.async {
                    self.isLoadData = false
                    self.tableView.tableFooterView = nil
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoadData = false
                    self.tableView.tableFooterView = nil
                }
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
            let key = self.measureDataList[indexPath.row].measureDate ?? ""
            guard let measureValue = FileManagerService.shared.getMeasureInfo(key: key) else { return }
            showVC.setMeasureData(data: measureValue)
            
            self.navigationController?.pushViewController(showVC, animated: true)
        }
        play.backgroundColor = .systemGreen
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            FileManagerService.shared.deleteMeasureFile(fileName: self.measureDataList[indexPath.row].measureDate!)
            CoreDataManager.shared.context.delete(self.measureDataList[indexPath.row])
            self.measureDataList.remove(at: indexPath.row)
            CoreDataManager.shared.saveContext()
            
            self.tableView.reloadData()
            self.fetchOffset -= 1
            success(true)
        }
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions:[delete, play])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let showVC = ShowViewController()
        showVC.viewType = .preview
        let key = measureDataList[indexPath.row].measureDate ?? ""
        guard let measureValue = FileManagerService.shared.getMeasureInfo(key: key) else { return }
        showVC.setMeasureData(data: measureValue)
        
        self.navigationController?.pushViewController(showVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.contentOffset.y > (tableView.contentSize.height - tableView.frame.size.height) + 100 {
            self.readMoreData()
        }
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
        let time = measureDataList[indexPath.row].measureDate
        let replaceTime = (time?.replacingOccurrences(of: "-", with: "/"))?.replacingOccurrences(of: "_", with: " ")
        
        cell.timeLabel.text = replaceTime
        cell.typeLabel.text = measureDataList[indexPath.row].sensorType
        cell.valueLabel.text = measureDataList[indexPath.row].measureTime
        
        return cell
    }
}

