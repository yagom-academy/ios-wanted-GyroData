//
//  MeasurmentViewController.swift
//  GyroData
//
//  Created by 유영훈 on 2022/09/20.
//

import UIKit

class MeasurmentViewController: UIViewController {
    
    private var secondView: UIViewController = {
        let secondView = UIViewController()
        return secondView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
