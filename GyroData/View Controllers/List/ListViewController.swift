//
//  ListViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit
import CoreData
import CoreMotion

final class ListViewController: UIViewController {
    
    var container: NSPersistentContainer!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        return tableView
    }()
    
    private var gyroDataList: [GyroData] = []
    private var detailDataList: [MotionDetailData] = []
    var date: Date?
    private var isLoading: Bool = false
    private let manager = FileManagerService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        configureNavigation()
        configureLayout()
        loadMoreData()
        
        manager.createDirectory()
        date = Date()
        let detailData = MotionDetailData(date: date!, x: 23.0, y: 4, z: 5)
        detailDataList.append(detailData)
        manager.saveToJSON(with: detailDataList)
    }
    
    private func configureNavigation() {
        navigationItem.title = "목록"
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정", style: .plain, target: self, action: #selector(didTapMeasureButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Load", style: .plain, target: self, action: #selector(didTapLoadDataButton))
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadMoreData() {
        if isLoading { return }
        isLoading = true
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            let pageSize = 10
            let newData = GyroDataRepository.shared.fetchData(firstIndex: self.gyroDataList.count, pageSize: pageSize)
            self.gyroDataList.append(contentsOf: newData)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.isLoading = false
            }
        }
    }
    
    private var timer: Timer!
    private let motion = CMMotionManager()
    private var isStop: Bool = true
    
    @objc
    private func didTapMeasureButton() {
        let measureViewController = MeasureViewController()
        show(measureViewController, sender: nil)
    }
    
    @objc
    private func didTapLoadDataButton() {
        let fetchRequest = DetailData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(DetailData.date), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            results.forEach { print(#function, $0.date, $0.x, $0.y, $0.z) }
        } catch {
            fatalError("Failed to fetch: \(error)")
        }
    }
    
    private func startAccelerometers() {
        var timeout = 10 // TODO: 600
        
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 6 / 60.0  // 10 Hz
            self.motion.startAccelerometerUpdates()
            
            self.timer = Timer(fire: Date(), interval: 0.1,
                               repeats: true, block: { (timer) in
                guard timeout > 0 else {
                    self.stopAccelerometers()
                    return
                }
                timeout -= 1
                if let data = self.motion.accelerometerData {
                    let x = data.acceleration.x
                    let y = data.acceleration.y
                    let z = data.acceleration.z
             
                    self.detailDataList.append(MotionDetailData(date: Date(), x: x, y: y, z: z))
                    print(#function, timeout, x, y, z)
                }
            })
            RunLoop.current.add(self.timer!, forMode: .default)
        }
    }
    
    @objc func didTapStopButton() {
        stopAccelerometers()
    }
    
    private func stopAccelerometers() {
        if timer != nil {
            self.timer.invalidate()
            timer = nil
            self.motion.stopAccelerometerUpdates()
        }
    }
    
    func saveAccelerometerData() {
        manager.saveToJSON(with: detailDataList)
        saveCoreData()
    }
    
    private func saveCoreData() {
        let context =  container.viewContext
        let data = DetailData(context: context)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        
        for detailData in detailDataList {
            data.date = formatter.string(from: detailData.date)
            data.x = detailData.x
            data.y = detailData.y
            data.z = detailData.z
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }
    
    func startGyros() {
        
        if motion.isGyroAvailable {
            var timeout = 10
            
            self.motion.gyroUpdateInterval = 10.0 / 60.0
            self.motion.startGyroUpdates()
            
            // Configure a timer to fetch the accelerometer data.
            self.timer = Timer(fire: Date(), interval: 0.1,
                               repeats: true, block: { (timer) in
                // Get the gyro data.
                
                if timeout > 0 {
                    timeout -= 1
                    if let data = self.motion.gyroData {
                        let x = data.rotationRate.x
                        let y = data.rotationRate.y
                        let z = data.rotationRate.z
                        print(#line, x, y, z)
                    }
                    // Use the gyroscope data in your app.
                } else {
                    self.stopGyros()
                }
            })
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer!, forMode: .default)
        }
    }
    
    func stopGyros() {
        
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
            
            self.motion.stopGyroUpdates()
            
        }
    }
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gyroDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        let gyroData = gyroDataList[indexPath.row]
        cell.dateLabel.text = gyroData.dateString
        cell.keyLabel.text = gyroData.type.rawValue
        cell.valueLabel.text = "\(gyroData.value)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == gyroDataList.count - 1 {
            loadMoreData()
        }
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: 세 번째 페이지를 view 타입으로 이동
        let viewController = UIViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let playAction = UIContextualAction(style: .normal, title: "Play") { action, view, handler in
            // TODO: 세 번째 페이지를 play 타입으로 이동
            print("touch Play Button")
        }
        playAction.backgroundColor = .systemGreen
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, handler in
            // TODO: 데이터를 삭제 (CoreData와 파일 모두 삭제할 것)
            print("touch Delete Button")
        }
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, playAction])
        return configuration
    }
}
