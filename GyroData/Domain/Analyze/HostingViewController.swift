//
//  HostingViewController.swift
//  GyroData
//
//  Created by unchain on 2022/12/29.
//

import SwiftUI

class HostingViewController: UIHostingController<AnyView> {

    init(model2: AnalyzeViewModel) {
        super.init(rootView: AnyView(GraphView().environmentObject(model2)))
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
