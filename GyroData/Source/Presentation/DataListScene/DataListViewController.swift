//
//  DataListViewController.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/31.
//

import UIKit

protocol AlertPresentable: AnyObject {
    func presentErrorAlert(title: String, message: String)
}

protocol DataListConfigurable: AnyObject {
    func setupData(_ datas: [MeasureData])
    func setupSelectData(_ data: MeasureData)
    func setupMeasure(_ transactionService: TransactionService)
    func setupPlay(_ data: MeasureData)
}

final class DataListViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Section, MeasureData>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MeasureData>

    private enum Constant {
        static let title = "목록"
    }
    
    enum Section {
        case main
    }
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let viewModel: DataListViewModel
    private lazy var dataSource = configureDataSoruce()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.action(.viewWillAppearEvent)
    }
    
    init(viewModel: DataListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setViewModelDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViewModelDelegate() {
        self.viewModel.delegate = self
        self.viewModel.alertDelegate = self
    }
}

// MARK: - DataListConfigurable Protocol
extension DataListViewController: DataListConfigurable {
    func setupData(_ datas: [MeasureData]) {
        applySnapshot(datas: datas, true)
    }
    
    func setupSelectData(_ data: MeasureData) {
        navigationController?.pushViewController(
            DetailViewController(viewModel: DetailViewModel(data: data)),
            animated: true
        )
    }
    
    func setupMeasure(_ transactionService: TransactionService) {
        let measureService = SensorMeasureService()
        let viewModel = MeasureViewModel(measureService: measureService, transactionService: transactionService)
        navigationController?.pushViewController(MeasureViewController(viewModel: viewModel), animated: true)
    }
    
    func setupPlay(_ data: MeasureData) {
        let viewModel = PlayViewModel(entireData: data)
        navigationController?.pushViewController(PlayViewController(viewModel: viewModel), animated: true)
    }
}

// MARK: - AlertPresentable Protocol
extension DataListViewController: AlertPresentable {
    func presentErrorAlert(title: String, message: String) {
        let errorAlert = AlertDirector().setupErrorAlert(
            builder: ErrorAlertBuilder(),
            title: title,
            errorMessage: message
        )
        present(errorAlert, animated: true)
    }
}

// MARK: - Action
extension DataListViewController {
    @objc private func measureButtonTapped() {
        viewModel.action(.measure)
    }
}

// MARK: - TableView Delegate Method
extension DataListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.action(.cellSelect(index: indexPath.row))
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let play = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, _ in
            self?.viewModel.action(.play(index: indexPath.row))
        }
        
        let delete = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, _ in
            self?.viewModel.action(.delete(index: indexPath.row))
        }
        
        let playLabel = UILabel(title: "Play", textStyle: .title1, backgroundColor: .systemGreen)
        
        play.image = UIImage(view: playLabel)
        play.backgroundColor = .systemGreen
        
        let deleteLabel = UILabel(title: "Delete", textStyle: .title1, backgroundColor: .systemRed)
        
        delete.image = UIImage(view: deleteLabel)
        delete.backgroundColor = .systemRed
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [delete, play])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
}

// MARK: - Configure DataSource, Snapshot
extension DataListViewController {
    private func configureDataSoruce() -> DataSource {
        let dataSource = DataSource(tableView: tableView) { tableView, indexPath, data in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MeasureDataCell.identifier,
                for: indexPath
            ) as? MeasureDataCell else {
                
                let errorCell = UITableViewCell()
                return errorCell
            }
            
            cell.setupData(data: data)
            return cell
        }
        return dataSource
    }
    
    private func applySnapshot(datas: [MeasureData], _ animaingDifferences: Bool) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(datas)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension DataListViewController {
    private func setupNavigationBar() {
        title = Constant.title
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGray5
        tableView.delegate = self
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let measureBarButton = UIBarButtonItem(
            title: "측정",
            style: .plain,
            target: self,
            action: #selector(measureButtonTapped)
        )
        
        navigationItem.rightBarButtonItem = measureBarButton
    }
    
    private func setupView() {
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MeasureDataCell.self, forCellReuseIdentifier: MeasureDataCell.identifier)
    }
    
    private func setupConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}
