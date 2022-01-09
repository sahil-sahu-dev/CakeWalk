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
            RoundedRectangle(cornerRadius: 5)
                .fill(color)
                .scaleEffect(CGSize(width: 1, height: value), anchor: .bottom)
        }
       
        
        
    }
}

struct BarChartCell_Previews: PreviewProvider {
    static var previews: some View {
        BarChartCell(value: 130, color:Color.orange)
            
    }
}
