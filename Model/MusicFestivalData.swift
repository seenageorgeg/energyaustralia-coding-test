//
//  MusicFestivalData.swift
//  EnergyAustraliaCodingTest
//
//  Created by Seena George on 05/04/23.
//

import Foundation
import SwiftUI


struct DataItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var subBands: [DataItem]?
    // var bands: [Bands]
    static let musicData: [DataItem] = Bundle.main.decode(file: "MusicData.json")
    
}

struct Bands: Codable {
    let name, recordLabel: String
}


// Main band record label
let recordLabel = [ DataItem(name: "Music Festival",  subBands: bandRecords)]

//// Sub-band items  and attended festivals for  Main band record label
let bandRecords = [ DataItem(name:"Electric Daisy Carnival" , subBands: [ DataItem(name: "Band X", subBands: [ DataItem(name: "Omega Festival")]), DataItem(name: "Band Y",subBands: [ DataItem(name: "Bamboozle")]) ]),
                    DataItem(name: "Mahindra Blues Festival", subBands: [ DataItem(name: "BandA", subBands: [ DataItem(name: "Alpha Festival"),DataItem(name: "Beta Festival")]) ]),
                    
                    DataItem(name: "Sunburn", subBands: [ DataItem(name: "GS3"), DataItem(name: "Riot Fest") ]),
                    DataItem(name: "The Beatles", subBands: [ DataItem(name: "UltraMusicFestival"), DataItem(name: "Lovers & Friends") ]),
                    DataItem(name: "VH1 Supersonic", subBands: [ DataItem(name: "Summmer Fest"), DataItem(name: "Pitchfork Music Festival") ])
]


// extension : Json decode

extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file) from bundle.")
        }
        
        return loadedData
    }
}
