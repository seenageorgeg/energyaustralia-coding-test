//
//  Helper.swift
//  EnergyAustraliaCodingTest
//
//  Created by Seena George on 10/04/23.
//

import Foundation
import SwiftUI
enum HTTPHeaderFields {
    case application_json
    case application_x_www_form_urlencoded
    case none
}

class Helper {
    func GET(url: String, params: [String: String], httpHeader: HTTPHeaderFields, complete: @escaping (Bool, Data?) -> ()) {
        guard var components = URLComponents(string: url) else {
            UtilityClass.showError(error: "Error: cannot create URLCompontents")
            return
        }
        components.queryItems = params.map { key, value in
            URLQueryItem(name: key, value: value)
        }

        guard let url = components.url else {
            UtilityClass.showError(error: "Error: cannot create URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        switch httpHeader {
        case .application_json:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .application_x_www_form_urlencoded:
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        case .none: break
        }

        
        // .ephemeral prevent JSON from caching (They'll store in Ram and nothing on Disk)
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                UtilityClass.showError(error: "Error: problem calling GET")
                complete(false, nil)
                return
            }
            guard let data = data else {
                UtilityClass.showError(error: "Error: did not receive data")
                complete(false, nil)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                guard let response = response as? HTTPURLResponse, response.statusCode == 429 else {
                    UtilityClass.showError(error: "Error: HTTP request failed")
                    complete(false, nil)
                    return
                }
                let errorMessage = String(data: data, encoding: String.Encoding.utf8)
                UtilityClass.showError(error: errorMessage ?? "")
                complete(false, nil)
                return
            }
            // MARK: NOTE TO EA - EXCEPTION HANDLING IN THIS API -- FOR STATUS CODE 200 , SOMETIME DATA IS COMIING EMPTY STRING
            if let emptyDataCheck = String(data: data, encoding: String.Encoding.utf8) {
                if let jsonDataToVerify = emptyDataCheck.data(using: .utf8)
                {
                    do {
                        _ = try JSONSerialization.jsonObject(with: jsonDataToVerify)
                    } catch {
                        UtilityClass.showError(title: "Please click on refresh", error: error.localizedDescription)
                        complete(false, nil)
                    }
                }
            }
            complete(true, data)
        }.resume()
    }
    
}

class UtilityClass {
    class func showError (title : String? = "Alert !!" , error : String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}
