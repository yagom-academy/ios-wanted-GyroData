//
//  Node.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

final class Node<Element> {
    let data: Element
    var next: Node<Element>?
    
    init(_ data: Element, next: Node<Element>? = nil) {
        self.data = data
        self.next = next
    }
}
