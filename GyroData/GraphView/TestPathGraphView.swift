//
//  GraphView.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/21.
//

import UIKit
import SwiftUI
import CoreGraphics

// TODO: 측정값이 범위 최대값보다 클 경우 스케일 다시 설정
// TODO: 테스트용 버튼 등을 만들어서 데이터를 하나씩 append + path가 제대로 그려지는지 확인
// TODO: GraphView가 superView에 add되고 오토레이아웃 활용하여 레이아웃 잡힌 상태에서도 제대로 동작하는지 확인
// TODO: 격자 그리드 뷰/효과 추가...여러 그래프에 나오는 격자효과 그거
// TODO: 스케일에 기반해 그리드 뷰도 조정 혹은 보정
// TODO: data 배열+path그래프가 화면의 가로 사이즈보다 커질 경우를 대비한 ScrollView 추가?
// TODO: 이미 그려진 path 일괄 삭제 처리. 정지버튼을 누르고 다시 재생할 경우 처음부터 재생해야 하므로

/*******. 두번째 페이지 *******/
/* graphView
 - acc 혹은 gyro 값들을 화면에 표시한다. acc, gyro 각 x: Red, y: Green, z: Blue의 선으로 표기
 - CAShapeLayer, UIBezierPath, CGMultiplePath 등을 이용해서 값들을 선으로 표시합니다.
 - y축은 초기 범위를 설정하고, 측정된 값이 범위의 최대값보다 클 경우 측정된 값 + (측정된 값 * 0.2) 로 하여 스케일을 다시 설정
 - y축 초기범위는 다시 측정할 경우 초기화
 - x축은 10hz로 60초동안 측정하므로 최대 총 600개의 데이터를 가짐
 */

/* 측정 버튼
 - 측정 버튼을 누르면 타이머가 동작하고, 10hz로 SegmentControl에 설정된 값에 따라서 acc 혹은 gyro의 x, y, z값을 가져옴
 - 타이머는 1초에 10개의 데이터를 가져올 수 있도록 0.1초로 설정하고, timeout 시간은 600.
 - 각 틱마다 x, y, z 값을 모두 저장.
 - 다시 측정하는 경우 기존의 값들을 초기화.
 */

/* 정지 버튼
 - 타이머가 동작할 때만 활성화.
 - 버튼을 누르면 타이머를 멈춤.
 */

/*
 - 측정된 값이 있을 경우 데이터를 CoreData와 FileManager를 이용해서 json으로 저장.
 - 값이 없을 경우 데이터가 없다는 알림을 표시.
 - 저장하는 json의 포맷은 자유롭게 설정.
 - 측정 중 저장버튼을 누를 수 없음.
 - 데이터 저장은 비동기로 처리, Activity Indicator를 표시.
 - 저장이 성공하면 Indicator를 닫고, 첫 번째 페이지로 이동.
 - 저장이 실패하면 Indicator를 닫고, 페이지를 이동하지않고 실패이유 적은 Alert을 띄움.
 */

/*******. 세번째 페이지 *******/
/*
 - 페이지타입은 play 타입과 view 타입...아무래도 첫번째 화면에서 didSelectRow를 누르면 view타입, 스와이프+play 버튼 누르면 play타입 을 띄우길 원하는듯
 - 네비바를 이용해 뒤로가기 지원필요
 - 측정시간을 타이틀로 표시
 - view타입은 GraphView 이용해서 FileManager로 불러온 모든 데이터를 선으로 표시 + 데이터를 한 번에 그래프로 표시해야 함
 - play타입은 타이머를 이용하여 데이터를 재생하는 화면. GraphView 이용하여 모든 데이터를 선으로 표시
   재생버튼, 정지버튼 포함
   재생버튼을 누르면 타이머가 동작. 인터벌은 0.1초. 총 600인터벌, 60초 동안 재생
   재생 시작시 재생버튼은 정지버튼으로 바뀜
   재생버튼 옆에는 재생시간을 표시. 0.1초 단위로 표시
   정지버튼을 누르고 다시 재생할 경우 처음부터 재생
   재생하면서 x y z 의 값에 기반해 GraphView의 선을 갱신.
   x y z 중 하나의 값이라도 없다면 재생을 멈춤
 */

struct ValueInfo {
    var xValue: CGFloat
    var yValue: CGFloat
    var zValue: CGFloat
}

class TestPathGraphView: UIView {
    
    //input
    var didReceiveData: (ValueInfo) -> () = { value in }
    
    //output
    
    //properties
    private var privateTempDataSource: [ValueInfo] = []
    
    lazy var middlePoint: CGPoint = CGPoint(x: 0.0, y: self.frame.height / 2)
    
    lazy var xPreviousPoint: CGPoint = CGPoint(x: 0, y: self.middlePoint.y)
    lazy var xNewPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    lazy var yPreviousPoint: CGPoint = CGPoint(x: 0, y: self.middlePoint.y)
    lazy var yNewPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    lazy var zPreviousPoint: CGPoint = CGPoint(x: 0, y: self.middlePoint.y)
    lazy var zNewPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    let xPath = UIBezierPath()
    let yPath = UIBezierPath()
    let zPath = UIBezierPath()
    
    init() {
        super.init(frame: .zero)
        initViewHierarchy()
        configureView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        print("draw called")
        drawZpath()
        drawYpath()
        drawXpath()
    }
    
    // TODO: 일단 path.close는 "path"를 완전히 다 그렸을 시 close 해줘야 하는 듯 하다. UIGraphicCurrentContext가 close해줘야 하는 것처럼
    //그런데 현 시점 기준으로는 close를 부르나 부르지 않으나 효과가 똑같다.
    //언제 path.close를 확실히 불러줘야 하는지에 대한 검증이 필요해 보인다.
    func drawXpath() {
        xPath.move(to: xPreviousPoint)
        
        let receivedData = privateTempDataSource.last?.xValue ?? 0.0
        
        xNewPoint = CGPoint(x: xPreviousPoint.x + 10, y: xPreviousPoint.y + receivedData)
        xPath.addLine(to: xNewPoint)
        
        xPreviousPoint = xNewPoint
        
        UIColor.red.setStroke()
        xPath.stroke()
    }
    
    func drawYpath() {
        yPath.move(to: yPreviousPoint)
        
        let receivedData = privateTempDataSource.last?.yValue ?? 0.0
        
        yNewPoint = CGPoint(x: yPreviousPoint.x + 10, y: yPreviousPoint.y + receivedData)
        yPath.addLine(to: yNewPoint)
        
        yPreviousPoint = yNewPoint
        
        UIColor.green.setStroke()
        yPath.stroke()
    }
    
    func drawZpath() {
        zPath.move(to: zPreviousPoint)
        
        let receivedData = privateTempDataSource.last?.zValue ?? 0.0
        
        zNewPoint = CGPoint(x: zPreviousPoint.x + 10, y: zPreviousPoint.y + receivedData)
        zPath.addLine(to: zNewPoint)
        
        zPreviousPoint = zNewPoint
        
        UIColor.blue.setStroke()
        zPath.stroke()
    }
}

extension TestPathGraphView: Presentable {
    func initViewHierarchy() {

    }
    
    func configureView() {
        self.backgroundColor = .white
        xPath.lineWidth = 1 //default
        yPath.lineWidth = 1 //default
        zPath.lineWidth = 1 //default
    }
    
    func bind() {
        didReceiveData = { [weak self] value in
            //드로잉을 위한 데이터소스 변경, 붙이기, 삭제 등 비즈니스 로직
            self?.privateTempDataSource.append(value)
            
            self?.setNeedsDisplay() //그 다음에 얘를 호출 //얘를 호출하면
            print("set needs display called")
            //다음 드로잉 사이클에 오버라이드한 draw가 불리게 될 것임
        }
    }
}

