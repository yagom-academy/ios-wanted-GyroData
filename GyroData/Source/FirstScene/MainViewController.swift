//
//  MainViewController.swift
//  GyroData
//
//  Created by inho on 2023/02/03.
//

import UIKit

class MainViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Section, MotionData>
    
    enum Section {
        case main
    }
    
    private let mainTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MotionDataCell.self, forCellReuseIdentifier: MotionDataCell.identifier)
        
        return tableView
    }()
    private var mainDataSource: DataSource?
    private var mainViewModel: MainViewModel = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureView()
        configureDataSource()
        bindViewModel()
        configureSnapShot(motionDatas: mainViewModel.motionDatas)
        mainTableView.delegate = self
        mainTableView.separatorStyle = .none
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "목록"
        navigationItem.rightBarButtonItem = .init(
            title: "측정",
            style: .plain,
            target: self,
            action: nil
        )
    }
    
    private func configureView() {
        view.addSubview(mainTableView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mainTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mainTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        mainViewModel.bindData { [weak self] motionDatas in
            self?.configureSnapShot(motionDatas: motionDatas)
        }
    }
}

extension MainViewController {
    private func configureDataSource() {
        mainDataSource = DataSource(tableView: mainTableView) { tableView, indexPath, data in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MotionDataCell.identifier,
                for: indexPath
            ) as? MotionDataCell else {
                return UITableViewCell()
            }
            
            let cellViewModel = MotionCellViewModel(motionData: data)
            
            cell.configureViewModel(cellViewModel)
            cellViewModel.convertCellData()
            
            return cell
        }
    }
    
    private func configureSnapShot(motionDatas: [MotionData]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, MotionData>()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(motionDatas)
        
        mainDataSource?.apply(snapShot, animatingDifferences: true)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
