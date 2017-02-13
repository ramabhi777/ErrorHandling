//
//  EMailModel.swift
//  ErrorHandling
//
//  Created by Abhishek Shukla on 18/10/16.
//  Copyright © 2016 InnovationM. All rights reserved.
//

import Foundation

struct EmailModel {
    let subject: String?
    let message: String?
    let recipients: [String]?
    let fileName: String?
    let fileType: String?
    let mimeType: String?
}
