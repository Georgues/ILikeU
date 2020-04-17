//
//  Constants.swift
//  ILikeU
//
//  Created by George Gostev on 15/04/2020.
//  Copyright © 2020 George Gostev. All rights reserved.
//

import Foundation
import CoreBluetooth

struct Constants {
    static let serviceID = CBUUID(string:"32c80358-7f20-11ea-bc55-0242ac130003")
    static let PSMID = CBUUID(string:CBUUIDL2CAPPSMCharacteristicString)
}
