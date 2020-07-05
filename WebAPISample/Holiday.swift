//
//  Holiday.swift
//  WebAPISample
//
//  Created by Kap's on 29/06/20.
//  Copyright © 2020 Kapil. All rights reserved.
//

import Foundation

struct HolidayResponse : Decodable {
    var response : Holidays
}

struct Holidays: Decodable {
    var holidays : [HolidayDetail]
}

struct HolidayDetail: Decodable {
    var name : String
    var date : DateInfo
}

struct DateInfo: Decodable {
    var iso : String
}
