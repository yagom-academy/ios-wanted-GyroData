//
//  Motion.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/27.
//

import UIKit

struct Motion {
    let date: String
    let measurementType: String
    let coordinate: Coordinate
}

public class Coordinate: NSObject, NSSecureCoding {
    public static var supportsSecureCoding = true
    
    enum Key: String {
        case x = "x"
        case y = "y"
        case z = "z"
    }
    
    let x: [Int]
    let y: [Int]
    let z: [Int]
    
    init(x: [Int], y: [Int], z: [Int]) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(x, forKey: "x")
        coder.encode(y, forKey: "y")
        coder.encode(z, forKey: "z")
    }
    
    public required convenience init?(coder: NSCoder) {
        let mX = coder.decodeObject(forKey: "x")
        let mY = coder.decodeObject(forKey: "y")
        let mZ = coder.decodeObject(forKey: "z")
        
        self.init(x: mX as! [Int], y: mY as! [Int], z: mZ as! [Int])
    }
}
