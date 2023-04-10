//
//  ContentView.swift
//  EnergyAustraliaCodingTest
//
//  Created by Seena George on 04/04/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var fetcher = FestivalDataFetcher()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(fetcher.processedRecords,id: \.id) { breed in
                    //                VStack(alignment: .leading, spacing: 5) {
                    
                    Section(header: Text(breed.recordName!)
                        .font(.title).bold()){
                            
                            
                            VStack(alignment: .leading, spacing: 15) {
                                
                                Text(breed.allBands!.joined(separator: "\n ")).font(.title2)
                                    .multilineTextAlignment(.leading)
                                .padding()}
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text(breed.allFestivals!.joined(separator: "\n ")).font(.title2)
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.trailing).padding()
                                
                                
                            }
                            
                        }
                    
                }.navigationTitle("MusicFestival List")
            }.listStyle(.insetGrouped)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
