//
//  SceneCategory.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation

//앱 전반적으로 present, push될 뷰컨트롤러의 열거형들
enum SceneCategory {
    case main(mainScene)
    case detail(detailScene)
    
    enum mainScene {
        case firstViewController
    }
    
    enum detailScene {
        case secondViewController
        case thirdViewController
    }
    
}
