//
//  TestPathView.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/22.
//

//Path 테스트 위해서 끄적이거나 모아놓은 것들
//참고용이므로 실제 사용은 자제.

import UIKit
import SwiftUI

class TestPathView: UIView {
    
    var linePath: UIBezierPath!
    var trianglePath: UIBezierPath!
    var squarePath: UIBezierPath!
    var loopLinePath: UIBezierPath!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func testDrawingFunc() {
        //path를 그리기 위한 로직을 돌린다
        createRectangle()
        
        //path로 감싼 영역을 특정한 색으로 채운다
        //simillar as background color
        UIColor.orange.setFill()
        squarePath.fill()
        
        //path가 지나간 영역에 특정한 색을 먹인다
        //simillar as border color
        UIColor.purple.setStroke()
        squarePath.stroke()

        createLinePath()
        
        UIColor.blue.setFill()
        linePath.fill()
        
        UIColor.red.setStroke()
        linePath.stroke()
        
        createPathWithLoop()
        
        UIColor.blue.setFill()
        loopLinePath.fill()
        
        UIColor.blue.setStroke()
        loopLinePath.stroke()
    }
    
    func createRectangle() {
        squarePath = UIBezierPath()
        
        // Specify the point that the path should start get drawn.
        squarePath.move(to: CGPoint(x: 0.0, y: 0.0))

        // Create a line between the starting point and the bottom-left side of the view.
        squarePath.addLine(to: CGPoint(x: 0.0, y: 100))
        
        // Create the bottom line (bottom-left to bottom-right).
        squarePath.addLine(to: CGPoint(x: 100, y: 100))
        
        // Create the vertical line from the bottom-right to the top-right side.
        squarePath.addLine(to: CGPoint(x: 100, y: 0.0))
        
        // Close the path. This will create the last line automatically.
        squarePath.close()
    }
    
    func createTriangle() {
        trianglePath = UIBezierPath()
        
        trianglePath.move(to: CGPoint(x: self.frame.width / 2, y: 0.0))
        trianglePath.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
        trianglePath.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        trianglePath.close()
    }
    
    func createLinePath() {
        linePath = UIBezierPath()
        
        let yMiddle = self.frame.height / 2
        linePath.move(to: CGPoint(x: 0, y: yMiddle))
        linePath.addLine(to: CGPoint(x: 10, y: yMiddle))
        
        linePath.move(to: CGPoint(x: 10, y: yMiddle))
        linePath.addLine(to: CGPoint(x: 20, y: yMiddle + 10))
        
        linePath.move(to: CGPoint(x: 20, y: yMiddle + 10))
        linePath.addLine(to: CGPoint(x: 30, y: yMiddle))
        
        linePath.move(to: CGPoint(x: 30, y: yMiddle))
        linePath.addLine(to: CGPoint(x: 40, y: yMiddle + 10))
        
        linePath.move(to: CGPoint(x: 40, y: yMiddle + 10))
        linePath.addLine(to: CGPoint(x: 80, y: yMiddle - 10))
        
        linePath.move(to: CGPoint(x: 80, y: yMiddle - 10))
        linePath.addLine(to: CGPoint(x: 100, y: yMiddle - 10))
        
        linePath.move(to: CGPoint(x: 100, y: yMiddle - 10))
        linePath.addLine(to: CGPoint(x: 120, y: yMiddle + 80))
        
        linePath.close()
    }
    
    //왜 안되지...아직 path 그리기에 대한 개념이 없나...
    //draw 메소드에선 루프를 돌리면 안되나...생각해보면 draw 메소드는 오토레이아웃 수정, path 등의 드로잉 행위를 할 때마다 불리긴 할 듯 함...
    func createPathWithLoop() {
        print("createPathWithLoop")
        loopLinePath = UIBezierPath()
        loopLinePath.lineWidth = 1.0 //default
        
        let yMiddle: CGFloat = 380 / 2
        var previousPoint: CGPoint = CGPoint(x: 0.0, y: yMiddle)
        
        for _ in 0...20 {
            let yRandomIncrement: CGFloat = CGFloat.random(in: -50...50)
            
            loopLinePath.move(to: previousPoint)
            
            let newPoint = CGPoint(x: previousPoint.x + 10, y: previousPoint.y + yRandomIncrement)
            
            loopLinePath.addLine(to: CGPoint(x: newPoint.x, y: newPoint.y))
            previousPoint = newPoint
        }
        loopLinePath.close()
    }
    
    //    func createPathWithTest() {
    //        let yRandomIncrement: CGFloat = CGFloat.random(in: -50...50)
    //
    //        loopLinePath.move(to: previousPoint)
    //
    //        let newPoint = CGPoint(x: previousPoint.x + 10, y: previousPoint.y + yRandomIncrement)
    //
    //        loopLinePath.addLine(to: CGPoint(x: newPoint.x, y: newPoint.y))
    //        previousPoint = newPoint
    //
    //        loopLinePath.close()
    //    }

}

#if canImport(SwiftUI) && DEBUG
struct TestPathViewPreview<View: UIView> : UIViewRepresentable {
    
    let view: View
    
    init(_ builder: @escaping () -> View) {
        view = builder()
    }
    
    func makeUIView(context: Context) -> some UIView {
        view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

#endif

#if canImport(SwiftUI) && DEBUG
struct TestPathViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        TestPathViewPreview {
            let view = TestPathView()
            
            return view
        }.previewLayout(.fixed(width: 300, height: 300))
    }
}

#endif
