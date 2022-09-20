//
//  FirstListView.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//
//testteesttest
import UIKit

class FirstListView: UIView {

    var tableView: UITableView = UITableView()
    var viewModel: FirstListViewModel
    
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
    }
    
    func bind() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
}

extension FirstListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(indexPath.row)
    }
}

extension FirstListView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
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
        let viewModel = FirstCellContentViewModel()
        cell.configureCell(viewModel: viewModel)
        return cell
    }
    
    
}
