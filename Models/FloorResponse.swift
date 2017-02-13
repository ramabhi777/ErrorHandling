//
//  FloorResponse.swift
//  ErrorHandling
//
//  Created by Abhishek Shukla on 14/10/16.
//  Copyright © 2016 InnovationM. All rights reserved.
//

import Foundation
import SwiftyJSON
import  CoreLocation

struct FloorResponse {
    
    let floorId: String
    let buildingId: String
    let floorNo: Int
    let geometry:Geometry
    let controlPoints: [ControlPoint]
    
    init(dict: SwiftyJSON.JSON) {
        floorId = dict["id"].stringValue
        buildingId = dict["building"].stringValue
        floorNo = dict["floorNumber"].intValue
        let jsonGeometry = dict["geometry"]
        geometry = Geometry(dict: jsonGeometry)
        let jsonPoints = dict["controlPoints"]
        controlPoints = ControlPoint.loadData(jsonPoints)
    }
    
    static func loadData(dict: SwiftyJSON.JSON) -> [FloorResponse] {
        
        var arrayOfFloors = [FloorResponse]()
        for (_, subDict) in dict {
            arrayOfFloors.append(FloorResponse(dict: subDict))
        }
        return arrayOfFloors
    }
    
    struct Geometry {
        let type: String
        var bottomLeft: CLLocationCoordinate2D = CLLocationCoordinate2D()
        var upperRight: CLLocationCoordinate2D = CLLocationCoordinate2D()

        
        init(dict: SwiftyJSON.JSON) {
            type = dict["type"].stringValue
            let bottomLeftDic = dict["bottomLeft"]
            bottomLeft.latitude = bottomLeftDic[0].doubleValue
            bottomLeft.longitude = bottomLeftDic[1].doubleValue
            
            let bottomUpperDic = dict["upperRight"]
            upperRight.latitude = bottomUpperDic[0].doubleValue
            upperRight.longitude = bottomUpperDic[1].doubleValue
        }
    }
    
    struct ControlPoint {
        let x: Int
        let y: Int
        let lon: Double
        let lan: Double
        
        init(dict: SwiftyJSON.JSON) {
            x = dict["x"].intValue
            y = dict["y"].intValue
            lon = dict["lon"].doubleValue
            lan = dict["lan"].doubleValue
        }
        
        static func loadData(dict: SwiftyJSON.JSON) -> [ControlPoint] {
            
            var arrayOfPoints = [ControlPoint]()
            for (_, subDict) in dict {
                arrayOfPoints.append(ControlPoint(dict: subDict))
            }
            return arrayOfPoints
        }
    }
}
