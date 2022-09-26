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
    case close //리프래시 등 아무것도 안 하고 닫는 경우
    indirect case closeAndRefresh(SceneCategory) //이전뷰 리프레시 등 뭔가를 해주기 + 닫기가 되어야 하는 경우
    case alert(AlertDependency)
    
    enum mainScene {
        case firstViewController(context: SceneContext<FirstModel>)
        case firstViewControllerForRefresh
    }
    
    enum detailScene {
        case secondViewController(context: SceneContext<SecondModel>)
        case thirdViewController(context: SceneContext<ThirdModel>)
    }
    
}
