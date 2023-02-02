//
//  ReviewPageViewController.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/02/02.
//

import UIKit

class ReviewPageViewController: UIViewController {
    
    private let reviewPageView: ReviewPageView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = reviewPageView
    }
    
    init(reviewPageView: ReviewPageView) {
        self.reviewPageView = reviewPageView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
