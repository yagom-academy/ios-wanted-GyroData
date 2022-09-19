//
//  Presentable.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation
import UIKit

//모든 뷰컨트롤러가 따라야 할 프로토콜
//loadView에서 처리한다
protocol Presentable {
    func initViewHierachy() //addsubview, autolayout
    func configureView() //viewColor, font, etc
    func bind() //bind to Model, ViewModel
}

