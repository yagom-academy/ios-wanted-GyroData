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
        
        return tableView
    }()
    private var mainDataSource: DataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureDataSource()
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
}

extension MainViewController {
    private func configureDataSource() {
        mainDataSource = DataSource(tableView: mainTableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MotionDataCell.identifier,
                for: indexPath
            ) as? MotionDataCell else {
                return UITableViewCell()
            }
            
            return cell
        }
    }
}
