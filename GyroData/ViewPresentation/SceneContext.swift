//
//  SceneContext.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//
//testteesttest
import Foundation

//각 뷰컨트롤러에 들어갈 Model, 즉 Dependency를 들고 있는 클래스
//뷰컨트롤러에서 다음 뷰컨트롤러로 넘어가도록 트리거가 발동되면 다음 뷰컨트롤러를 위한 SceneContext 인스턴스를 만들고, context인스턴스 안에 Model을 넣어줌
//ViewController 초기화 할 때 Model을 넣어줌
class SceneContext<Dependnecy> {
    var dependency: Dependnecy
    init(dependency: Dependnecy) {
        self.dependency = dependency
    }
}
