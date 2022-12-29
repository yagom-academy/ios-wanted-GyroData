//
//  GraphView.swift
//  GyroData
//
//  Created by unchain, Ellen J, yeton on 2022/12/27.
//

import Charts
import SwiftUI
import Combine


struct GraphView: View {
    var dummyData: [Analysis] = []
    
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
