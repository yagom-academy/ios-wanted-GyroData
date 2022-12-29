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
    @EnvironmentObject var environment: AnalyzeViewModel
    
    var dummyData: [GraphModel] = [
        .init(x: 1, y: 2, z: 3, measurementTime: 10),
        .init(x: 2, y: 3, z: 4, measurementTime: 20),
        .init(x: 3, y: 4, z: 5, measurementTime: 30),
        .init(x: 4, y: 5, z: 6, measurementTime: 40),
        .init(x: 5, y: 6, z: 7, measurementTime: 50)
    ]
    
    let dummyData2: [GyroData] = []
    
    var body: some View {
        ZStack(alignment: .top) {
            GroupBox {
                FigureView()
                
                Chart {
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
                .onAppear {
                    environment.bind()
                }
                .chartXScale(domain: 0...60, range: .plotDimension(padding: 20))
                .padding()
            }
            .border(.black, width: 1)
            .backgroundStyle(.white)
        }
    }
    
    struct FigureView: View {
        @ObservedObject var viewModel2 : AnalyzeViewModel
        var body: some View {
            HStack {
                Text("xdata")
                    .font(.caption2)
                    .foregroundColor(.red)
                    .onTapGesture {
                        viewModel2.tapAnalyzeButton()
                    }
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
