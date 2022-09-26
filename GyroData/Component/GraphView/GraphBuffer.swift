//
//  GraphBuffer.swift
//  GyroData
//
//  Created by 김지인 on 2022/09/27.
//

import UIKit

//그래프의 포인트 데이터를 저장,사용하기 위한 클래스
class GraphBuffer {
    
    var array: [CGFloat?]
    var index = 0
    var count: Int {
        return array.count
    }
    //입력한 count 크기 만큼 배열을 생성한다
    init(count: Int) {
        array = Array(repeating: nil, count: count)
    }
    
    //배열 초기화 메소드
    func resetToValue(_ value: CGFloat?) {
        let count = array.count
        array = Array(repeating: value, count: count)
    }
    //현재 인덱스에 element값을 넣는다
    //index는 호출될때 마다 1씩 증가하며, count 만큼 증가한다면 다시 index는 0을 향하게 된다.
    func write(_ element: CGFloat) {
        array[index % array.count] = element
        index += 1
    }
    //현재 그래프의 경로 값들을 넘겨준다
    //현재 인덱스의 값부터 시작되는 새로운 배열을 만들고, 고차 함수를 이용해 옵셔널바인딩 하여 리턴 하게 된다
    //이전 경로의 마지막 값이 index 0 이 된다
    func nextItems() -> [CGFloat] {
        var result = Array<CGFloat?>()
        for loop in 0..<array.count {
            result.append(array[(loop+index) % array.count])
        }
        return result.compactMap { $0 }
    }
}
