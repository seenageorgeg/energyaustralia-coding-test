//
//  ContentView.swift
//  EnergyAustraliaCodingTest
//
//  Created by Seena George on 04/04/23.
//

import SwiftUI

struct ContentView: View {
    //    @ObservedObject var datas = ReadData()
    
    var body: some View {
        NavigationView {
            
            List {
                
                ForEach(recordLabel) { menuItem in
                    
                    Section(header:
                                HStack {
                        
                        Text(menuItem.name)
                            .font(.title3)
                            .fontWeight(.heavy)
                        
                    }
                        .padding(.vertical)
                            
                    ) {
                        
                        OutlineGroup(menuItem.subBands ?? [DataItem](), children: \.subBands) {  item in
                            HStack {
                            
                                Text(item.name)
                                    .font(.system(.title3, design: .rounded))
                                    .bold()
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
