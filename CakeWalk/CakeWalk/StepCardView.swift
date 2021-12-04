//
//  StepCardView.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 27/11/21.
//

import SwiftUI

struct StepCardView: View {
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
            VStack(alignment: .leading) {
                Text("1200 Calories")
                Text("Distance")
                Text("Steps")
            }
        }
    }
    

}

struct StepCardView_Previews: PreviewProvider {
    static var previews: some View {
        StepCardView()
    }
}
