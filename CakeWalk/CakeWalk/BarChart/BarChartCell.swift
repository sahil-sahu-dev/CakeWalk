//
//  BarChartCell.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 07/01/22.
//

import SwiftUI

struct BarChartCell: View {
    
    var value: Double
    var color: Color
    
    
    var body: some View {
        
        GeometryReader{ geometry in
            ZStack{
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(color)
                    .scaleEffect(CGSize(width: 1, height: value), anchor: .bottom)
            }
            
        }
       
        
        
    }
}

struct BarChartCell_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            BarChartCell(value: 10, color:Color.orange)
            BarChartCell(value: 1230, color:Color.orange)
            BarChartCell(value: 110, color:Color.orange)
            BarChartCell(value: 90, color:Color.orange)
        }
        
            
    }
}
