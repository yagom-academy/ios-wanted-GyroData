//
//  TableView.swift
//  GyroData
//
//  Created by unchain, Ellen J, yeton on 2022/12/28.
//

import UIKit
import Combine

final class AnalyzeListViewController: UIViewController {
    private let listViewModel = AnalyzeListViewModel()
    private var cancelable = Set<AnyCancellable>()

    private let analysisTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AnalysisTableViewCell.self, forCellReuseIdentifier: AnalysisTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(r: 16, g: 17, b: 21, a: 1)
        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "목록"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    private lazy var analyzeButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "측정"
        button.tintColor = UIColor(r: 21, g: 198, b: 238, a: 1)
        button.target = self
        button.action = #selector(tabButton)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        view = analysisTableView
        self.navigationItem.titleView = titleLabel
        self.navigationItem.rightBarButtonItem = analyzeButton
        setTableView()
        listViewModel.input.onViewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listViewModel.input.onViewWillAppear()
        analysisTableView.reloadData()
    }
    
    private func setTableView() {
        self.analysisTableView.delegate = self
        self.analysisTableView.dataSource = self
    }
    
    @objc private func tabButton() {
        self.navigationController?.pushViewController(AnalyzeViewController(), animated: true)
    }
}

extension AnalyzeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listViewModel.analysis.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnalysisTableViewCell.identifier, for: indexPath) as? AnalysisTableViewCell else { return AnalysisTableViewCell() }
        
        cell.configureCell(at: indexPath, cellData: listViewModel.analysis)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let play = UIContextualAction(style: .normal, title: "Play") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.listViewModel.input.playButtonDidTap(indexPath: indexPath)
        }
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.listViewModel.input.deleteButtonDidTap(indexPath: indexPath)
            self.analysisTableView.reloadData()
        }
        
        play.backgroundColor = .systemGreen
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete, play])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.listViewModel.input.cellDidTap(indexPath: indexPath)
    }
    
    private func bind() {
        listViewModel.selectedItemPublisher
            .sink { [weak self] model in
                guard let self = self else { return }
                self.navigationController?.pushViewController(
                    GraphRecordViewController(
                        graphRecordViewModel: GraphRecordViewModel(model: model), isViewMode: true),
                    animated: true
                )
            }
            .store(in: &cancelable)
        
        listViewModel.playModePublisher
            .sink { [weak self] model in
                guard let self = self else { return }
                self.navigationController?.pushViewController(
                    GraphRecordViewController(graphRecordviewModel: GraphRecordViewModel(model: model)),
                    animated: true
                )
            }
            .store(in: &cancelable)
    }
}
