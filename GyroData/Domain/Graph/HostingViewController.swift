//
//  HostingViewController.swift
//  GyroData
//
//  Created by Ellen J, unchain, yeton on 2022/12/29.
//

import SwiftUI

final class HostingViewController: UIHostingController<AnyView> {
    init(model: EnvironmentGraphModel) {
        super.init(rootView: AnyView(GraphView().environmentObject(model)))
    }
    
    @objc required dynamic init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
