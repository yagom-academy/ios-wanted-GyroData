//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

class ViewController: UIViewController {

    let listView = ListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        self.view = listView
        
        listView.tableView.delegate = self
        listView.tableView.dataSource = self
    }
    
    private func setupInitialView() {
        listView.backgroundColor = .systemBackground
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListViewCell.identifier, for: indexPath) as! ListViewCell
        
        return cell
    }
    
    
}
