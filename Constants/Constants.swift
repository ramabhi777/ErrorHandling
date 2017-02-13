//
//  Constants.swift
//  ErrorHandling
//
//  Created by Abhishek Shukla on 14/10/16.
//  Copyright © 2016 InnovationM. All rights reserved.
//

import Foundation

struct Constants {
    static let domain = "com.innovationm.errorhandling"
    static let workspaceBaseUrl = "https://staging.goindoor.co/ws/v2/sql/buildings/90c85998-ce4b-4821-ad2d-953c6ac15158/floo"
    
    static let ERROR_REPORT_RECIPIENTS: [String] = ["abhishek.shukla@innovationm.com"]
}

class ConstantsHeader {
    static func getHeader() -> [String : String] {
        var headers = ["account": "My office", "password": "office@123"]
        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        return headers
    }
}
