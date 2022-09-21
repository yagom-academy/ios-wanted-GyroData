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

        // 네비게이션 아이템 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정", style: .plain, target: self, action: #selector(goToMeasureDataVC))

        dummyData()

        fetchData()
    }

    func dummyData() {
        let dummy = MotionData(context: self.context)
        dummy.date = "2022/9/21 15:19:44"
        dummy.dataType = "ACC"
        dummy.measureTime = "3"
        dummy.motionX = [
            -0.2180023193359375,
             -0.20611572265625,
             -0.197418212890625,
             -0.1961669921875,
             -0.1987457275390625,
             -0.1987152099609375,
             -0.1944427490234375,
             -0.195220947265625,
             -0.192352294921875,
             -0.192169189453125,
             -0.1955108642578125,
             -0.1943206787109375,
             -0.197357177734375,
             -0.1916351318359375,
             -0.1906280517578125,
             -0.189697265625,
             -0.194854736328125,
             -0.1953887939453125,
             -0.1993255615234375,
             -0.1927032470703125,
             -0.196197509765625,
             -0.1900787353515625,
             -0.192352294921875,
             -0.189361572265625,
             -0.1924896240234375,
             -0.193878173828125,
             -0.1955413818359375,
             -0.19256591796875,
             -0.188934326171875,
             -0.1915740966796875
        ]
        dummy.motionY = [
            -0.606536865234375,
             -0.615936279296875,
             -0.61956787109375,
             -0.626312255859375,
             -0.6267547607421875,
             -0.6236572265625,
             -0.6140899658203125,
             -0.619964599609375,
             -0.6212921142578125,
             -0.619720458984375,
             -0.619873046875,
             -0.6200103759765625,
             -0.61737060546875,
             -0.61688232421875,
             -0.620849609375,
             -0.62310791015625,
             -0.620208740234375,
             -0.619293212890625,
             -0.616546630859375,
             -0.6154327392578125,
             -0.6191864013671875,
             -0.6177978515625,
             -0.6194610595703125,
             -0.621826171875,
             -0.61761474609375,
             -0.615509033203125,
             -0.6179656982421875,
             -0.616790771484375,
             -0.619110107421875,
             -0.6222686767578125
        ]
        dummy.motionZ = [
            -0.754669189453125,
             -0.7184600830078125,
             -0.763580322265625,
             -0.75860595703125,
             -0.7632293701171875,
             -0.7557220458984375,
             -0.74560546875,
             -0.758270263671875,
             -0.7597503662109375,
             -0.7373046875,
             -0.7603302001953125,
             -0.7439422607421875,
             -0.7471923828125,
             -0.75732421875,
             -0.7606658935546875,
             -0.7529296875,
             -0.7616424560546875,
             -0.78363037109375,
             -0.780120849609375,
             -0.749176025390625,
             -0.738800048828125,
             -0.7328948974609375,
             -0.7559814453125,
             -0.755767822265625,
             -0.7545623779296875,
             -0.7464752197265625,
             -0.75140380859375,
             -0.7677154541015625,
             -0.7774810791015625,
             -0.7677764892578125
        ]

        do {
            try context.save()
        } catch {
            print(error)
        }
    }

    func fetchData() {
        let request: NSFetchRequest<MotionData> = MotionData.fetchRequest()

        do {
            motionDataArray = try context.fetch(request)
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modity = UIContextualAction(style: .normal, title: "Play") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("play")
            success(true)
        }
        modity.backgroundColor = .systemGreen
        
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("delete")
            success(true)
        }
        delete.backgroundColor = .systemRed
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions:[delete, modity])
        swipeActionConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeActionConfiguration
    }

}


