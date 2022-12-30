//
//  GraphRecordViewController.swift
//  GyroData
//
//  Created by unchain, Ellen J, yeton on 2022/12/30.
//

import UIKit

final class GraphRecordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubviews(GraphRecordView(frame: view.frame))
    }
}
