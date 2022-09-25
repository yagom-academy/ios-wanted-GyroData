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
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func bind() {
        viewModel.didReceiveViewModel = { [weak self] _ in
            DispatchQueue.main.async {
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.motionDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FirstListCell else {
            fatalError()
        }
        
        //temp
        //model이 만들어둔 cellViewModel을 잘 넘겨줄 수 있도록 추가 처리 필요
        let viewModel = FirstCellContentViewModel(viewModel.motionDatas[indexPath.row])
        cell.configureCell(viewModel: viewModel)
        
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = .grayThird
        } else {
            cell.backgroundColor = .white
        }
        return cell
    }
}
