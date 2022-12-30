//
//  HostingViewController.swift
//  GyroData
//
//  Created by Ellen J, unchain, yeton on 2022/12/29.
//

import SwiftUI

class HostingViewController: UIHostingController<AnyView> {
    init(model2: EnvironmentGraphModel) {
        super.init(rootView: AnyView(GraphView().environmentObject(model2)))
    }
    
    @objc required dynamic init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
