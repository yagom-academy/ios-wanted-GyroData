//
//  LimitedQueue.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

final class LimitedQueue<Element> {
    private let maxCount = Int(GyroRecorder.Constant.frequency * 60)
    
    private(set) var head: Node<Element>?
    private(set) var tail: Node<Element>?
    
    var isEmpty: Bool {
        return head == nil
    }
    
    var count: Int = 0 {
        didSet {
            if count > maxCount {
                head = head?.next
                count -= 1
            }
        }
    }
    
    @discardableResult
    func dequeue() -> Element? {
        if isEmpty { return nil }
        
        let data = head?.data
        head = head?.next
        count -= 1
        
        return data
    }
    
    func enqueue(_ data: Element) {
        let node = Node(data)
        
        if isEmpty {
            head = node
            tail = node
        } else {
            tail?.next = node
            tail = tail?.next
        }
        
        count += 1
    }
    
    func clear() {
        head = nil
        tail = nil
    }
    
    // for test
    var realCount: Int {
        guard !isEmpty else {
            return 0
        }
        
        var count = 1
        var node = head
        
        while node?.next != nil {
            node = node?.next
            count += 1
        }
        
        return count
    }
}
