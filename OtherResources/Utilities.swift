//
//  Utilities.swift
//  ErrorHandling
//
//  Created by Abhishek Shukla on 02/11/16.
//  Copyright © 2016 InnovationM. All rights reserved.
//

import Foundation

class Utilities  {
    
    static func getFilePath() -> String {
        
        let filePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        return filePath + "/"
    }
}
