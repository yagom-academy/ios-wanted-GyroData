//
//  Node.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import Foundation

final class Node<Element> {
    private(set) var data: Element
    var next: Node<Element>?
    
    init(data: Element, next: Node<Element>? = nil) {
        self.data = data
        self.next = next
    }
}
