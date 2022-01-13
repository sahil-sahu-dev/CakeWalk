//
//  BarChart.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 07/01/22.
//

import SwiftUI

struct BarChart: View {
    
    var title: String
    var legend: String
    var barColor: Color
    var data: [ChartData]
    
    var x: CGFloat
    var y: CGFloat
    
    @State private var currentValue = ""
    @State private var currentLabel = ""
    
    @State private var touchLocation: CGFloat = -1
    
    var body: some View {
        
        
            
            
            VStack(alignment: .leading) {
            Text(title)
                .bold()
                .font(.title)
            Text(currentValue.isEmpty == true ? "" : "\(currentLabel): \(currentValue)")
                .font(.headline)
            
                GeometryReader { geometry in
                VStack {
                    HStack {
                        ForEach(0..<data.count, id: \.self) { i in
                            BarChartCell(value: normalizedValue(index: i), color: barColor)
                                .opacity(barIsTouched(index: i) ? 1 : 0.7)
                                .scaleEffect(barIsTouched(index: i) ? CGSize(width: 1.05, height: 1) : CGSize(width: 1, height: 1), anchor: .bottom)
                                .animation(.spring())
                                .padding(.top)
                            
                        }
                    }
                    .gesture(DragGesture(minimumDistance: 0)
                                .onChanged{position in
                        let touchPosition = position.location.x/geometry.frame(in: .local).width
                        
                        touchLocation = touchPosition
                        updateCurrentValue()
                    }
                                .onEnded{ _ in
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(Animation.easeOut(duration: 0.5)) {
                                touchLocation = -1
                                currentValue  =  ""
                                currentLabel = ""
                            }
                        }
                    }
                    )
                    
                    
                    if !currentLabel.isEmpty {
                        Text(currentLabel)
                        
                            .bold()
                            .foregroundColor(.black)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.white).shadow(radius: 3))
                            .offset(x: labelOffset(in: geometry.frame(in: .local).width))
                            .animation(.easeIn)
                    }
                }
            }
        
        }
            .frame(width: x * 0.45, height: y*0.33)
            .padding()
            .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.white).shadow(radius: 5))
    }
    
    
    func normalizedValue(index: Int) -> Double {
        var allValues: [Double]    {
            var values = [Double]()
            for data in data {
                values.append(data.value)
            }
            return values
        }
        guard let max = allValues.max() else {
            return 1
        }
        if max != 0 {
            return Double(data[index].value)/Double(max)
        } else {
            return 1
        }
    }
    
    func barIsTouched(index: Int) -> Bool {
        touchLocation > CGFloat(index)/CGFloat(data.count) && touchLocation < CGFloat(index+1)/CGFloat(data.count)
    }
    
    func updateCurrentValue()    {
        let index = Int(touchLocation * CGFloat(data.count))
        guard index < data.count && index >= 0 else {
            currentValue = ""
            currentLabel = ""
            return
        }
        currentValue = "\(data[index].value)"
        currentLabel = data[index].label
    }
    
    func labelOffset(in width: CGFloat) -> CGFloat {
        let currentIndex = Int(touchLocation * CGFloat(data.count))
        guard currentIndex < data.count && currentIndex >= 0 else {
            return 0
        }
        let cellWidth = width / CGFloat(data.count)
        let actualWidth = width -    cellWidth
        var position = cellWidth * CGFloat(currentIndex) - actualWidth/2
        if currentIndex == 0 {
            position += 30
        }
        if currentIndex == data.count - 1 {
            position -= 30
        }
        return position
    }
}

//struct BarChart_Previews: PreviewProvider {
//    static var previews: some View {
//        //BarChart(title: "Monthly Sales", legend: "EUR", barColor: .blue, data: chartDataSet)
//            
//    }
//}
