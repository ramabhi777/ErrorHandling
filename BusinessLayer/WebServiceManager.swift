//
//  WebServiceManager.swift
//  ErrorHandling
//
//  Created by Abhishek Shukla on 13/10/16.
//  Copyright © 2016 InnovationM. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct ApiStruct {
    let url: String
    let type: Alamofire.Method
    let header: [String: String]?
    let body: [String: AnyObject]?
}

class WebServiceManager: NSObject{
    
    private let methodName = "WebServiceManager.getResponse"
    
    private var afManager: Alamofire.Manager?
    private let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    private let errorManager = ErrorManager.sharedInstance
    
    static let sharedInstance = WebServiceManager()
    private override init() {
        configuration.timeoutIntervalForRequest = 30
        self.afManager = Alamofire.Manager(configuration: configuration, serverTrustPolicyManager: nil)
    }
    
    func getResponse(apiStruct: ApiStruct, onSuccess: (response: JSON) -> Void, onFailure: (serverError: ErrorModel?) -> Void) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        afManager?.request(apiStruct.type, apiStruct.url, parameters: apiStruct.body, encoding: .JSON, headers: apiStruct.header).validate().responseJSON(completionHandler: { (response) in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if response.result.isSuccess {
                
                let responseJSON = JSON(response.result.value!)
                onSuccess(response: responseJSON)
            }
            else {
                
                let errorModel = ErrorModel.error(code: ErrorModel.ErrorCode_WebService.serverError.rawValue, failureReason: (response.result.error?.description)!, methodName: self.methodName, nsError: response.result.error!)
                self.errorManager.reportErrorToCrashlitics(errorModel)
                self.errorManager.reportErrorToLogFile(errorModel)
                onFailure(serverError: errorModel)
            }
        })
    }
    
}
