//
//  SecondViewTests.swift
//  GyroDataTests
//
//  Created by CodeCamper on 2022/09/26.
//

import XCTest
@testable import GyroData

class SecondViewTests: XCTestCase {
    var secondVC: SecondViewController!
    var secondModel: SecondModel!
    
    override func setUpWithError() throws {
        let repository = Repository()
        let motionManager = CoreMotionTestManager()
        secondModel = SecondModel(repository: repository, motionManager: motionManager)
        secondVC = SecondViewController(viewModel: secondModel)
        secondVC.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        secondVC = nil
        secondModel = nil
    }

    func test측정_중에는_타입이_변경되지_않아야합니다() throws {
        // given
        let segmentView = secondVC.segmentView
        
        // when
        secondModel.controlViewModel.didTapMeasureButton()
        
        // then
        XCTAssertFalse(segmentView.segmentedControl.isEnabled)
    }
    
    func test다시_측정하는_경우_기존의_값들을_초기화합니다() throws {
        // given
        secondModel.controlViewModel.didTapMeasureButton()
        secondModel.controlViewModel.didTapStopButton()
        var previousMeasures = [MotionMeasure]()
        secondModel.motionMeasuresSource = { measures in
            previousMeasures = measures
        }
        XCTAssertGreaterThan(previousMeasures.count, 0)
        
        // when
        var nextMeasures = [MotionMeasure]()
        secondModel.motionMeasuresSource = { measure in
            nextMeasures = measure
        }
        secondModel.controlViewModel.didTapMeasureButton()
        
        // then
        XCTAssertEqual(previousMeasures.count, nextMeasures.count)
        XCTAssertNotEqual(previousMeasures, nextMeasures)
    }
}
