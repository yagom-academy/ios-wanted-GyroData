//
//  SendDataDelegate.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/29.
//

import Foundation

protocol SendDataDelegate: AnyObject {
    func sendData<T> ( _ data: T)
}
