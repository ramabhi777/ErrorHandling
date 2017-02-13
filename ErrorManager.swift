
//
//  ErrorHandlingManager.swift
//  ErrorHandling
//
//  Created by Abhishek Shukla on 06/10/16.
//  Copyright © 2016 InnovationM. All rights reserved.
//

import Foundation
import Crashlytics

//enum ApplicationErrorType: ErrorType {
//    case WebService
//    case FileManager
//}

public struct ErrorManager {
    
    private let errorTitle = "Error Description"
    private let errorMethodTitle = "Error Method"
    private let errorCodeTitle = "Error Code"
    private let errorMessageTitle = "Error Message"
    
    static let sharedInstance = ErrorManager()
    private init() {}
    
    func reportErrorToCrashlitics(errorModel: ErrorModel) {
        
        // Send Report to Crashlytics
        let dic:[String:String] = [self.errorTitle : errorModel.errorMessage!, self.errorMethodTitle: errorModel.errorMethod!]
        let nsError = NSError(domain: Constants.domain, code: errorModel.errorCode!, userInfo: dic)
        Crashlytics.sharedInstance().debugMode = true
        Crashlytics.sharedInstance().recordError(nsError)
    }
    
    func reportErrorToLogFile(errorModel: ErrorModel) {
        
        // Send Report to Log file
        let contentToWrite = prepareErrorFileContent(errorModel)
        let fileObj = FileManager.sharedInstance
        fileObj.writeFile(contentToWrite, onSuccess: { (message) in
            print(message)
            }, onFailure: { (message) in
                print(message)
        })
    }
    
    private func prepareErrorFileContent(errorModel: ErrorModel) -> String{
        let contentToWrite = self.errorCodeTitle + ":" +  "\(errorModel.errorCode)" + self.errorMessageTitle + ":" + "\(errorModel.errorMessage)" + self.errorMethodTitle + ":" + "\(errorModel.errorMethod)"
        return contentToWrite
    }
    
}

