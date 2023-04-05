//
//  MusicViewModel.swift
//  EnergyAustraliaCodingTest
//
//  Created by Seena George on 05/04/23.
//

import Foundation
import SwiftUI

class ReadData: ObservableObject  {
    @Published var users = [DataItem]()
    
        
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "MusicData", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        
        let data = try? Data(contentsOf: url)
        let users = try? JSONDecoder().decode([DataItem].self, from: data!)
        self.users = users!
        
    }
     
}
