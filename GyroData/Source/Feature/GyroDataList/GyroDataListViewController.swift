//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit
import CoreData

class GyroDataListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var motionDataArray = [MotionData]()
    var offset = 0
    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(GyroDataListTableViewCell.self, forCellReuseIdentifier: GyroDataListTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 90
        tableView.translatesAutoresizingMaskIntoConstraints = false

        self.title = "목록"
        self.view.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정", style: .plain, target: self, action: #selector(goToMeasureDataVC))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchData()
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

    func saveData() {
        do {
            try self.context.save()
        } catch {
            print(error)
        }
    }

    func fetchData() {
        let request: NSFetchRequest<MotionData> = MotionData.fetchRequest()
        request.fetchLimit = 10
        request.fetchOffset = offset

        do {
            let nextMotionDataArray = try context.fetch(request)
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

    //MeasureViewController 로 간다
    @objc fileprivate func goToMeasureDataVC(){
        let measureDataVC = MeasureDataViewController()
        self.navigationController?.pushViewController(measureDataVC, animated: true)
    }

    // tableView Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return motionDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GyroDataListTableViewCell.identifier, for: indexPath) as? GyroDataListTableViewCell
        else { return UITableViewCell() }

        cell.dataTypeLabel.text = motionDataArray[indexPath.row].dataType
        cell.dateLabel.text = motionDataArray[indexPath.row].date
        cell.timeLabel.text = motionDataArray[indexPath.row].measureTime

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
            print("play")
            let playGyroViewController = PlayGraphViewController()

            guard let motionInfo = FileService.shared.getMotionInfo(name: self.motionDataArray[indexPath.row].date) else { return }
            
            playGyroViewController.setMotionInfo(motionInfo)

            self.navigationController?.pushViewController(playGyroViewController, animated: true)
            success(true)
        }
        modity.backgroundColor = .systemGreen
        
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in

            FileService.shared.deleteJSON(fileName: self.motionDataArray[indexPath.row].date)
            self.context.delete(self.motionDataArray[indexPath.row])
            self.motionDataArray.remove(at: indexPath.row)

            print("delete")

            self.saveData()
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


