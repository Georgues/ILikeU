//
//  CentralManagerExtension.swift
//  ILikeU
//
//  Created by George Gostev on 03/04/2020.
//  Copyright © 2020 George Gostev. All rights reserved.
//

import Foundation
import CoreBluetooth

extension MapViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            case .unknown:
                print("central.state is .unknown")
            case .resetting:
                print("central.state is .resetting")
            case .unsupported:
                print("central.state is .unsupported")
            case .unauthorized:
                print("central.state is .unauthorized")
            case .poweredOff:
                print("central.state is .poweredOff")
            case .poweredOn:
                print("central.state is .poweredOn")
              centralManager.scanForPeripherals(withServices: [BLEModels.serviceUUID])
            default:
                print("Unknown error for CentralManger.state")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        print("\(String(describing: peripheral.name))")
        availablePeripherals.append(peripheral)
        central.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral!")
        peripheral.delegate = self
        peripheral.discoverServices([BLEModels.serviceUUID])
    }
    
    
    
}
