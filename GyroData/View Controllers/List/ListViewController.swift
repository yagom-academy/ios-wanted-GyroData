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
    private var isLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        configureNavigation()
        configureLayout()
        loadMoreData()
    }
    
    private func configureNavigation() {
        navigationItem.title = "목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정", style: .plain, target: self, action: #selector(didTapMeasureButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Load", style: .plain, target: self, action: #selector(didTapLoadDataButton))
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        
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
        // TODO: 두 번째 페이지로 이동
        //        startAccelerometers()
        if isStop == true {
            startGyros()
            isStop = false
            navigationItem.rightBarButtonItem?.title = "중단"
        } else {
            stopGyros()
            isStop = true
            navigationItem.rightBarButtonItem?.title = "측정"
        }
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
                    self.saveAccelerometerData(x: x, y: y, z: z)
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
    
    func saveAccelerometerData(x: Double, y: Double, z: Double, date: Date = Date()) {
        let context = container.viewContext
        let accelerometerData = DetailData(context: context)
        accelerometerData.x = x
        accelerometerData.y = y
        accelerometerData.z = z
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        accelerometerData.date = formatter.string(from: date)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
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
