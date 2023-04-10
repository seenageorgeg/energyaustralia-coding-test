//
//  MusicViewModel.swift
//  EnergyAustraliaCodingTest
//
//  Created by Seena George on 05/04/23.
//

import Foundation

class FestivalDataFetcher: ObservableObject {
    
    @Published var processedRecords = [AllRecordsModel]()
    @Published var processedBands = [String]()
    @Published var processedFestivals = [AllFestivals]()
    
    
    private var recordService: RecordsServiceProtocol
    
    init(recordService: RecordsServiceProtocol = RecordsService()) {
        self.recordService = recordService
        getProcessedRecord()
        
        //        fetchAllBreeds()
    }
    
    
    
    func getProcessedRecord() {
        recordService.getRecords { success, records in
            guard success else { return }
            guard let finalRecords = records else { return }
            self.processedRecords = finalRecords
           // self.processedBands = processedRecords["allBand"].allBands ?? []
            
            print(self.processedRecords)
        }
    }
}
