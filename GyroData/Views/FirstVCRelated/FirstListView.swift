//
//  FirstListView.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import UIKit

class FirstListView: UIView {
    // MARK: UI
    var tableView: UITableView = UITableView()
    
    // MARK: Properties
    var viewModel: FirstListViewModel
    
    // MARK: Init
    init(viewModel: FirstListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        initViewHierarchy()
        configureView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Presentable
extension FirstListView: Presentable {
    func initViewHierarchy() {
        self.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        constraint += [
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
    }
    
    func configureView() {
        tableView.register(FirstListCell.self, forCellReuseIdentifier: "cell")
        tableView.register(FirstListLoadingCell.self, forCellReuseIdentifier: "loadingCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func bind() {
        viewModel.propagateFetchMotionTasks = { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.propagateStartPaging = { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadSections(IndexSet(integer: 1), with: .none)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.viewModel.didReceiveEndPaging()
                self?.tableView.reloadData()
            }
        }
    }
}

extension FirstListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let play = UIContextualAction(style: .normal, title: "Play") { [weak self] action, sourceView, completionHandler in
            self?.viewModel.didSelectPlayAction(indexPath.row)
            completionHandler(true)
        }
        play.backgroundColor = .success
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { action, sourceView, completionHandler in
            completionHandler(true)
        }
        delete.backgroundColor = .destructive
        
        let configuration = UISwipeActionsConfiguration(actions: [delete, play])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}

extension FirstListView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.motionTasks.count
        } else if section == 1 && viewModel.isPaging && viewModel.isScrollAvailable() {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FirstListCell else {
                fatalError()
            }
            
            //temp
            //model이 만들어둔 cellViewModel을 잘 넘겨줄 수 있도록 추가 처리 필요
            let viewModel = FirstCellContentViewModel(viewModel.motionTasks[indexPath.row])
            cell.configureCell(viewModel: viewModel)
            
            if indexPath.row % 2 == 1 {
                cell.backgroundColor = .grayThird
            } else {
                cell.backgroundColor = .white
            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as? FirstListLoadingCell else {
                fatalError()
            }
            
            let viewModel = FirstLoadingCellContentViewModel()
            cell.configureCell(viewModel: viewModel)
            cell.cellView.activityIndicatorView.startAnimating()
            
            return cell
        }
    }
}

extension FirstListView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > (contentHeight - height) {
            if !viewModel.isPaging && viewModel.isScrollAvailable() {
                viewModel.didReceiveStartPaging()
            }
        }
    }
}
