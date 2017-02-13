//
//  ErrorModel.swift
//  ErrorHandling
//
//  Created by Abhishek Shukla on 18/10/16.
//  Copyright © 2016 InnovationM. All rights reserved.
//

import Foundation

public struct ErrorModel {
    let error: NSError!
    let errorCode: Int!
    let errorMessage: String!
    let errorMethod: String!
    
    public static let Domain = "com.innovationM.errorManager"
    
    public enum ErrorCode_WebService: Int {
        case serverError = 1000
    }
    
    public enum ErrorCode_FileManager: Int {
        case fileRead = 2000
        case fileWrite = 2001
        case fileCreate = 2002
        case fileDelete = 2003
    }
    
    public enum ErrorCode_Mail: Int {
        case mailSent = 3000
        case mailFailed = 3001
        case mailCancelled = 3002
        case mailSaved = 3003
    }
    
    static func error(domain: String = ErrorModel.Domain, code: Int, failureReason: String, methodName: String, nsError: NSError) -> ErrorModel {
        return ErrorModel(error: nsError, errorCode: code, errorMessage: failureReason, errorMethod: methodName)
    }
    
}

