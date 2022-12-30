//
//  MotionEntity+Mapping.swift
//  GyroData
//
//  Created by Ari on 2022/12/26.
//

import Foundation
import CoreData

extension MotionEntity {
    
    convenience init(motion: Motion, context: NSManagedObjectContext) {
        self.init(context: context)
        self.uuid = motion.uuid
        self.date = motion.date
        self.type = motion.type.title
        self.duration = motion.duration
    }
    
}
