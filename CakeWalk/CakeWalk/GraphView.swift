//
//  GraphView.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 12/12/21.
//

import SwiftUI

struct GraphView: View {
    
    var flameImage: some View {
        Image(systemName: "flame.fill").foregroundColor(.orange)
    }
    
    var body: some View {
        
            
        ZStack{
            //Color(.init(white: 0, alpha: 0.15)).edgesIgnoringSafeArea(.all)
            ScrollView{
                barView
            }
                
        }
            
        .navigationTitle("Steps")
    }
    
    
    var barView: some View {
        
        HStack{
            VStack{
                Bar(height: 40)
            }
            VStack{
                Bar(height: 90)
            }
            VStack{
                Bar(height: 40)
            }
            VStack{
                Bar(height: 400)
            }
            
        }
        
    }
}


struct Bar: View {
    var height: CGFloat
    
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            Capsule().frame(width: 30, height: 400).foregroundColor(.clear)
            
            Capsule().frame(width: 30, height: height).foregroundColor(.orange)
            
        }
        
        
    }
    
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
