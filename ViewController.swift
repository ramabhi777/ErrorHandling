//
//  ViewController.swift
//  ErrorHandling
//
//  Created by Abhishek Shukla on 06/10/16.
//  Copyright © 2016 InnovationM. All rights reserved.
//

import UIKit
import Foundation
import Fabric
import Crashlytics
import Social

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.prepareView()
    }
    
    func prepareView() {
        let taskManger = ServerTaskManager.sharedInstance
        
        taskManger.getFloorList({ (responseArray) in
            
            for floorObj:FloorResponse in responseArray {
                
                print(floorObj.geometry.bottomLeft.latitude,
                      floorObj.geometry.bottomLeft.longitude,
                      floorObj.geometry.upperRight.latitude,
                      floorObj.geometry.upperRight.longitude)
                
            }
        }) { (serverError) in
            
            let emailManager = EMailManager.sharedInstance
            emailManager.reportError(self, errorModel: serverError!, onSuccess: { (errroModel) in
                // Success
                print("Success")
                }, onFailure: { (errorModel) in
                    // Failure
                    print("Failure")
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

