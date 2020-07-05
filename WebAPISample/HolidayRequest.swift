//
//  HolidayRequest.swift
//  WebAPISample
//
//  Created by Kap's on 29/06/20.
//  Copyright © 2020 Kapil. All rights reserved.
//

import Foundation

enum HolidayError : Error {
    case noDataAvailable
    case canNotProcessData
}

struct HolidayRequest {
    
    let resourceURL : URL
    let API_KEY = "51cb2bc083a02bdbe0d27e7a89f46c664731085d"
    
    init(countryCode : String) {
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        
        let currentYear = format.string(from: date)
        
        let resourceString = "https://calendarific.com/api/v2/holidays?api_key=\(API_KEY)&country=\(countryCode)&year=\(currentYear)"
        
        guard let resourceURL = URL(string: "\(resourceString)") else { fatalError() }
        
        self.resourceURL = resourceURL
    }
    
    func getHolidays(completion : @escaping ( Result<[HolidayDetail], HolidayError> ) -> Void ) {
        
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { (data, _ , _ ) in
            
            guard let jsonData = data else {
                
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let holidayResponse = try decoder.decode(HolidayResponse.self, from: jsonData)
                let holidayDetails = holidayResponse.response.holidays
                completion(.success(holidayDetails))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
        
    }
}
