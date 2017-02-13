//
//  FileManager.swift
//  ErrorHandling
//
//  Created by Abhishek Shukla on 13/10/16.
//  Copyright © 2016 InnovationM. All rights reserved.
//

import Foundation

class FileManager {
    
    private let errorMessageWriteTitile = "Failure, File write operation"
    private let errorMessageReadTitile = "Failure, File write operation"
    private let errorMessageDeleteTitile = "Failure, File write operation"
    private let errorMessageCreateTitile = "Failure, File write operation"
    
    private let errorMethodWriteTitle = "FileManager.createFile()"
    private let errorMethodReadTitle = "FileManager.ReadFile()"
    private let errorMethodCreateTitle = "FileManager.CreateFile()"
    private let errorMethodDeleteTitle = "FileManager.DeleteFile()"
    private let successString = "Success"
    private let failureString = "Failure"
    private let errorFile = "Error.txt"
    
    let fileManager = NSFileManager.defaultManager()
    
    static let sharedInstance = FileManager()
    private init() {}
    
    func writeFile(contentToWrite: String, onSuccess:(message: String) -> Void, onFailure: (message: String) -> Void) {
        
        if isFileExist() {
            self.readFile({ (message) in
                let fileContentToWrite = message + "\n \(contentToWrite)"
                
                do {
                    try fileContentToWrite.writeToFile(Utilities.getFilePath() + self.errorFile, atomically: true, encoding: NSUTF8StringEncoding)
                    onSuccess(message: self.successString)
                }
                catch {
                    onFailure(message: self.failureString)
                }
                
                }, onFailure: { (message) in
                    onFailure(message: message)
            })
        }
        else {
            self.createFile({ (message) in
                onSuccess(message: "File Created")
                }, onFailure: { (message) in
                    onFailure(message: message)
            })
        }
    }
    
    func readFile(onSuccess:(message: String) -> Void, onFailure: (message: String) -> Void) {
        var contentString = ""
        do {
            let filePath =  (Utilities.getFilePath() + self.errorFile)
            contentString = try NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding) as String
            onSuccess(message: contentString)
        }
        catch {
            onFailure(message: self.failureString)
        }
    }
    
    private func isFileExist() -> Bool {
        var isExist = false
        let everythingSwiftFilePath = Utilities.getFilePath() + self.errorFile
        if(fileManager.fileExistsAtPath(everythingSwiftFilePath))
        {
            isExist = true
        }
        
        return isExist
    }
    
    private func createFile(onSuccess:(message: String) -> Void, onFailure: (message: String) -> Void) {
        let contents = ""
        do {
            try contents.writeToFile(Utilities.getFilePath() + self.errorFile, atomically: true, encoding: NSUTF8StringEncoding)
            onSuccess(message: self.successString)
        }
        catch {
            onFailure(message: self.failureString)
        }
    }
    
    func deleteFie(onSuccess:(message: String) -> Void, onFailure: (message: String) -> Void) {
        do {
            try fileManager.removeItemAtPath(Utilities.getFilePath() + self.errorFile)
            onSuccess(message: self.successString)
        }
        catch {
            onFailure(message: self.failureString)
        }
    }
}

