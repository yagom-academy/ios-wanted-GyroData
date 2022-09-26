//
//  ReplayViewModel.swift
//  GyroData
//
//  Created by 김지인 on 2022/09/21.
//

import Foundation
import UIKit


class ReplayViewModel {
    enum PageType: String {
        case view = "View"
        case play = "Play"
    }
    
    var buttonState: Bool = false
    var measureDate: String?
    var playType: PageType?
    
    func startButtonTap(completion: @escaping () -> ()) {
        
    }
    
}
