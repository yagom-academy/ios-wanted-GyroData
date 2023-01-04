//
//  MotionListViewController.swift
//  GyroData
//
//  Created by 이호영 on 2022/12/27.
//

import UIKit

final class MotionListViewController: UIViewController {

    private lazy var motionListTableView: UITableView = {
       let tableView = UITableView()
       tableView.delegate = self
       tableView.dataSource = self
       tableView.register(
           MotionListTableViewCell.self,
           forCellReuseIdentifier: MotionListTableViewCell.cellIdentifier
       )
       tableView.translatesAutoresizingMaskIntoConstraints = false
       return tableView
   }()
    
    private let indicatorView: UIRefreshControl = {
        let indicatorView = UIRefreshControl()
        return indicatorView
    }()
    
    private var viewModel: MotionListViewModel = MotionListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureNavigationBar()
        bind(to: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadItems()
    }

    private func setupView() {
        addSubViews()
        setupConstraints()
        view.backgroundColor = .systemBackground
    }
    
    private func addSubViews() {
        view.addSubview(motionListTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            motionListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            motionListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            motionListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            motionListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bind(to viewModel: MotionListViewModel) {
        viewModel.items.subscribe() { [weak self] _ in self?.updateItem() }
    }
}

// MARK: TableView Delegate

extension MotionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushMotionResultScene(resultType: .view, information: self.viewModel.items.value[indexPath.row])
    }
}

// MARK: TableView DataSource

extension MotionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MotionListTableViewCell.cellIdentifier, for: indexPath) as? MotionListTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configure(information: self.viewModel.items.value[indexPath.row])
        return cell
    }
    
    private func updateItem() {
        DispatchQueue.main.async {
            self.motionListTableView.reloadData()
        }
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let offsetY = motionListTableView.contentOffset.y
         let contentHeight = scrollView.contentSize.height
         let height = scrollView.frame.height
         
         if offsetY > (contentHeight - height) {
             if !viewModel.isloading.value {
                 self.viewModel.loadItems()
             }
         }
    }
}

// MARK: NavigationController

extension MotionListViewController {
    private func configureNavigationBar() {
        let measurementBarButton = UIBarButtonItem(title: "측정",
                                            style: .done,
                                            target: self,
                                            action: #selector(measurementBarButtonTapped))

        navigationItem.rightBarButtonItem = measurementBarButton
        navigationItem.title = "목록"
    }

    @objc private func measurementBarButtonTapped() {
        let measurementViewController = MeasurementViewController()
        navigationController?.pushViewController(measurementViewController, animated: true)
    }
    
    private func pushMotionResultScene(resultType: MotionResultType, information: MotionInformation) {
        let motionResultViewModel = MotionResultViewModel(information)
        
        switch resultType {
        case .view:
            let motionResultViewController = MotionResultViewController(viewModel: motionResultViewModel)
            navigationController?.pushViewController(motionResultViewController, animated: true)
        case .play:
            let motionResultPlayViewController = MotionResultPlayViewController(viewModel: motionResultViewModel)
            navigationController?.pushViewController(motionResultPlayViewController, animated: true)
        }
        
    }
}

// MARK: TableView SwipeAction

extension MotionListViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let playAction = UIContextualAction(style: .normal, title: "Play") { _, _, completionHandler in
            self.pushMotionResultScene(resultType: .play, information: self.viewModel.items.value[indexPath.row])
            completionHandler(true)
        }
        playAction.backgroundColor = .systemGreen
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { _, _, completionHandler in
            self.viewModel.deleteItem(information: self.viewModel.items.value[indexPath.row])
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction, playAction])
    }
}
