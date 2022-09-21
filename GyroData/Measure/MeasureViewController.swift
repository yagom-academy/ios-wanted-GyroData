//
//  MeasureViewController.swift
//  GyroData
//
//  Created by 김지인 on 2022/09/21.
//

import UIKit

class MeasureViewController: UIViewController {
    
    let mainView = MeasureView()
    
    override func loadView() {
        self.view = mainView
        self.navigationItem.title = "측정하기"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        // Do any additional setup after loading the view.
    }
    
    func setup() {
        mainView.segmentControl.selectedSegmentIndex = 0
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정", style: .plain, target: self, action: #selector(saveAction))
    }
    
    // MARK: incomplete
    @objc func saveAction() {
        print("저장")
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
