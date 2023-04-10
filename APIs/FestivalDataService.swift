//
//  FestivalDataService.swift
//  EnergyAustraliaCodingTest
//
//  Created by Seena George on 10/04/23.
//

import Foundation
import SwiftUI

protocol RecordsServiceProtocol {
    func getRecords(completion: @escaping (_ success: Bool,
        _ results: [AllRecordsModel]?) -> ())
}

class RecordsService: RecordsServiceProtocol {
    
    func getRecords(completion: @escaping (Bool, [AllRecordsModel]?) -> ()) {
        Helper().GET(url: EndPoints.festivalList.url, params: ["": ""], httpHeader: .application_json) { success, data  in
            if success {
                do {
                    guard let dataAvailable = data else { completion(false, nil); return }
                    let object = try JSONSerialization.jsonObject(with: dataAvailable, options: .allowFragments)
                    if let nonFormatedDict = object as? [[String: AnyObject]] {
                        let formatedDict = self.processedRecordsHierarchy(nonFormatedDict: nonFormatedDict)
                        self.decode(modelType: [AllRecordsModel].self, fromObject: formatedDict) { records in
                            completion(true, records)
                        }
                    }
                } catch {
                    completion(false, nil)
                }
            } else {
                completion(false, nil)
            }
        }
    }
    
    func decode<T>(modelType: T.Type, fromObject: Any, _ genericModel: @escaping (T) -> Void) where T: Decodable {
        do {
            let socketForHostData = try JSONSerialization.data(withJSONObject: fromObject)
            do {
                let finalModel = try JSONDecoder().decode(modelType, from: socketForHostData)
                genericModel(finalModel)
            } catch let err {
                UtilityClass.showError(error: err.localizedDescription)
            }
        } catch _ { }
    }
    
    // MARK: listing out music festival data in a particular manner: at the top level, it should show the band record label, below that it should list out all bands under their management, and below that it should display which festivals they've attended.
    
    
    func fetchAllRecords (dict :[[String: AnyObject]]) -> [String]{
        var recordArray = [String]()
        dict.forEach { unformattedDictObj in
            guard let unFormatedbands = unformattedDictObj["bands"] as? [[String : Any]] else { return }
            unFormatedbands.forEach { unFormatedbandObj in
                if let recordLabel = unFormatedbandObj["recordLabel"] as? String {
                    let modifiedRecordName = recordLabel == "" ? Constants.recordNameMissing : recordLabel
                    if !recordArray.contains(modifiedRecordName) {
                        recordArray.append(modifiedRecordName)
                    }
                }
            }
        }
        return recordArray.sorted()
    }
   
    
    func processedRecordsHierarchy (nonFormatedDict :[[String: AnyObject]]) -> [[String: Any]] {
        var processedDict = [[String: Any]]()
        var recordArray = [String]()
        recordArray = self.fetchAllRecords(dict: nonFormatedDict)
        recordArray.forEach { singleRecord in
            var singleRecordBand = [String]()
            var singleRecordFests = [String]()
            for item in nonFormatedDict {
                guard let unFormatedbands = item["bands"] as? [[String : Any]]  else { continue }
                for mainband in unFormatedbands {
                    guard let recodLable = mainband["recordLabel"] as? String else { continue }
                    let modifiedRecordName = recodLable == "" ? Constants.recordNameMissing : recodLable
                    guard modifiedRecordName == singleRecord else { continue }
                    if let bandName = mainband["name"] as? String , !singleRecordBand.contains(bandName) {
                        singleRecordBand.append(bandName)
                    }
                    if let bandsFestName = item["name"] as? String , !singleRecordFests.contains(bandsFestName) {
                        singleRecordFests.append(bandsFestName)
                    }
                }
            }
            var processedObj = [String : Any]()
            processedObj["recordName"] = singleRecord
            processedObj["allBands"] = singleRecordBand.sorted()
            processedObj["allFestivals"] = singleRecordFests.sorted()
            processedDict.append(processedObj)
        }
        return processedDict
    }

}
struct Constants {
    static let recordNameMissing = "Record name missing"
    static let bandNameMissing = "Band name is empty"
}
