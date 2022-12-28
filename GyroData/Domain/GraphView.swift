//
//  GraphView.swift
//  GyroData
//
//  Created by unchain on 2022/12/27.
//

import Charts
import SwiftUI

let dummyData: [Analysis] = [
    .init(analysisType: .accelerate, x: 1, y: 2, z: 3, measurementTime: 10.0, savedAt: Date()),
    .init(analysisType: .accelerate, x: 2, y: 3, z: 3, measurementTime: 20.0, savedAt: Date()),
    .init(analysisType: .accelerate, x: 3, y: 4, z: 3, measurementTime: 30.0, savedAt: Date()),
    .init(analysisType: .accelerate, x: 4, y: 5, z: 3, measurementTime: 40.0, savedAt: Date()),
    .init(analysisType: .accelerate, x: 5, y: 6, z: 3, measurementTime: 50.0, savedAt: Date()),
    .init(analysisType: .accelerate, x: 6, y: 7, z: 3, measurementTime: 60.0, savedAt: Date())
]

struct GraphView: View {
    var body: some View {
        ZStack(alignment: .top) {
            GroupBox {
                FigureView()
                Chart() {
                    ForEach(dummyData, id: \.measurementTime) { data in
                        LineMark(
                            x: .value("Time", data.measurementTime),
                            y: .value("value", data.x),
                            series: .value("value", "x")
                        )
                        .foregroundStyle(.red)
                        .lineStyle(StrokeStyle(lineWidth: 1, lineCap: .round))
                    }
                    ForEach(dummyData, id: \.measurementTime) { data in
                        LineMark(
                            x: .value("Time", data.measurementTime),
                            y: .value("value", data.y),
                            series: .value("value", "y")
                        )
                        .foregroundStyle(.green)
                        .lineStyle(StrokeStyle(lineWidth: 1, lineCap: .round))
                    }
                    ForEach(dummyData, id: \.measurementTime) { data in
                        LineMark(
                            x: .value("Time", data.measurementTime),
                            y: .value("value", data.z),
                            series: .value("value", "z")
                        )
                        .foregroundStyle(.blue)
                        .lineStyle(StrokeStyle(lineWidth: 1, lineCap: .round))
                    }
                }
                .chartXScale(domain: 0...60, range: .plotDimension(padding: 20))
                .padding()
            }
            .border(.black, width: 1)
            .backgroundStyle(.white)
        }
    }
    
    struct FigureView: View {
        var body: some View {
            HStack {
                Text("xdata")
                    .font(.caption2)
                    .foregroundColor(.red)
                Spacer()
                Text("ydata")
                    .font(.caption2)
                    .foregroundColor(.green)
                Spacer()
                Text("zdata")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
            .padding([.top, .leading, .trailing], 30)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
