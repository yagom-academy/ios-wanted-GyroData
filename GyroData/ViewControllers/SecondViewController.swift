//
//  SecondViewController.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import UIKit

class SecondViewController: UIViewController, SecondViewControllerRoutable {

    override func loadView() {
        initViewHierarchy()
        configureView()
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

extension SecondViewController: Presentable {
    func initViewHierarchy() {
        self.view = UIView()
    }
    
    func configureView() {
        view.backgroundColor = .yellow
    }
    
    func bind() {
        
    }
}
