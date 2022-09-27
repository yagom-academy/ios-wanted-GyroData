//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit
import CoreData

class GyroDataListViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(GyroDataListTableViewCell.self, forCellReuseIdentifier: GyroDataListTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 90
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var motionDataArray = [MotionData]()
    var offset = 0
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProperties()
        addViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func setProperties() {
        self.title = "목록"
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정", style: .plain, target: self, action: #selector(goToMeasureDataVC))
    }
    
    func addViews() {
        view.addSubview(tableView)
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.color = UIColor.darkGray
            spinner.hidesWhenStopped = true
            spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 60)
            tableView.tableFooterView = spinner
            spinner.startAnimating()
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                self.fetchData()
            }
        }
    }

    func fetchData() {
        let request: NSFetchRequest<MotionData> = MotionData.fetchRequest()
        request.fetchLimit = 10
        request.fetchOffset = offset
        
        do {
            let nextMotionDataArray = try CoreDataService.shared.context.fetch(request)
            if nextMotionDataArray.isEmpty {
                DispatchQueue.main.async {
                    self.tableView.tableFooterView = nil
                    self.isLoading = false
                }
            } else {
                motionDataArray += nextMotionDataArray
                offset += nextMotionDataArray.count
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.isLoading = false
                    self.tableView.tableFooterView = nil
                }
            }
        } catch {
            print("<<Error fetching data from context>>")
            print(error)
        }
    }

    @objc fileprivate func goToMeasureDataVC(){
        let measureDataVC = MeasureDataViewController()
        self.navigationController?.pushViewController(measureDataVC, animated: true)
    }
}
    
extension GyroDataListViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return motionDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GyroDataListTableViewCell.identifier, for: indexPath) as? GyroDataListTableViewCell
        else { return UITableViewCell() }

        cell.setLabel(motionDataArray[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        let showGraphViewController = ShowGraphViewController()

        guard let motionInfo = FileService.shared.getMotionInfo(name: motionDataArray[indexPath.row].date) else { return }
        
        showGraphViewController.setMotionInfo(motionInfo)

        self.navigationController?.pushViewController(showGraphViewController, animated: true)
    }


    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modity = UIContextualAction(style: .normal, title: "Play") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            let playGyroViewController = PlayGraphViewController()
            guard let motionInfo = FileService.shared.getMotionInfo(name: self.motionDataArray[indexPath.row].date) else { return }
            playGyroViewController.setMotionInfo(motionInfo)
            self.navigationController?.pushViewController(playGyroViewController, animated: true)
            success(true)
        }
        modity.backgroundColor = .systemGreen
        
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in

            FileService.shared.deleteJSON(fileName: self.motionDataArray[indexPath.row].date)
            CoreDataService.shared.context.delete(self.motionDataArray[indexPath.row])
            self.motionDataArray.remove(at: indexPath.row)
            CoreDataService.shared.saveContext()
            self.tableView.reloadData()

            success(true)
        }
        delete.backgroundColor = .systemRed
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions:[delete, modity])
        swipeActionConfiguration.performsFirstActionWithFullSwipe = false
        return swipeActionConfiguration
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.contentOffset.y > (tableView.contentSize.height - tableView.frame.size.height) + 80 {
            loadMoreData()
        }
    }
}
