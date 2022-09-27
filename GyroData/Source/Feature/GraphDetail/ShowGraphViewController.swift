//
//  ShowGraphViewController.swift
//  TestGyroData
//
//  Created by 엄철찬 on 2022/09/25.
//

import UIKit

class ShowGraphViewController: UIViewController {

    lazy var showGraphView: ShowGraphView = {
        let view = ShowGraphView(motionInfo ?? MotionInfo())
        return view
    }()
    
    var motionInfo : MotionInfo?

    override func loadView() {
        self.view = showGraphView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProperties()
        setLabelValue()
    }
    
    func setProperties() {
        self.title = motionInfo?.measureTime ?? "다시 보기"
    }
    
    func setMotionInfo(_ motionInfo:MotionInfo){
        self.motionInfo = motionInfo
    }
    
    func extractMaxValue(_ motion:[Double]) -> String {
        let positiveMax = motion.max() ?? 0.0
        let negativeMax = motion.min() ?? 0.0
        return String(format:"%.2f", abs(positiveMax) > abs(negativeMax) ? positiveMax : negativeMax )
    }
    
    func setLabelValue(){
        showGraphView.xLabel.text = "x:" + extractMaxValue(motionInfo?.motionX ?? [])
        showGraphView.yLabel.text = "y:" + extractMaxValue(motionInfo?.motionY ?? [])
        showGraphView.zLabel.text = "z:" + extractMaxValue(motionInfo?.motionZ ?? [])
    }
}
