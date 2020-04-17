//
//  CoreBluetoothModels.swift
//  ILikeU
//
//  Created by George Gostev on 03/04/2020.
//  Copyright © 2020 George Gostev. All rights reserved.
//

import Foundation
import CoreBluetooth

struct BLEModels {
    
    static let serviceUUID = CBUUID(string: "ff68acd4-7028-11ea-bc55-0242ac130003")
    static let userInfoUUID = CBUUID(string: "ff68af5e-7028-11ea-bc55-0242ac130003")
    static let descriptionUUID = CBUUID(string: "f5485f34-74dc-11ea-bc55-0242ac130003")
    static let sendInfoUUID = CBUUID(string: "ff68b080-7028-11ea-bc55-0242ac130003")
    static var nameData:Data?
    static var descriptionData: Data?
    static var sendData: Data?
    
}
