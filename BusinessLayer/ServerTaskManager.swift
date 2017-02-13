//
//  ServerTaskManager.swift
//  ErrorHandling
//
//  Created by Abhishek Shukla on 14/10/16.
//  Copyright © 2016 InnovationM. All rights reserved.
//

import Foundation
import SwiftyJSON

class ServerTaskManager {
    
    private let errorMethodTitle = "WebServiceManager.GetResponse()"
    
    static let sharedInstance = ServerTaskManager()
    private init() {}
    
    func getFloorList(onSuccess: (responseArray: [FloorResponse]) -> Void, onFailure: (serverError: ErrorModel?) -> Void) {
        
        let headerObj = ConstantsHeader.getHeader()
        let apiObj = ApiStruct(url: Constants.workspaceBaseUrl, type: .GET, header: headerObj, body: nil)
        let webServiceManager = WebServiceManager.sharedInstance
        
        webServiceManager.getResponse(apiObj, onSuccess: { (response) in
            
            if !response {
                print(response)
                let arrayOfFloors = FloorResponse.loadData(response["data"])
                onSuccess(responseArray: arrayOfFloors)
            }
            
        }) { (serverError) in
            onFailure(serverError: serverError)
        }
    }
}

