//
//  PeripheralManagerExtension.swift
//  ILikeU
//
//  Created by George Gostev on 03/04/2020.
//  Copyright © 2020 George Gostev. All rights reserved.
//

import Foundation
import CoreBluetooth

extension MapViewController: CBPeripheralManagerDelegate, CBPeripheralDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
          case .unknown:
            print("peripheral.state is .unknown")
          case .resetting:
            print("peripheral.state is .resetting")
          case .unsupported:
            print("peripheral.state is .unsupported")
          case .unauthorized:
            print("peripheral.state is .unauthorized")
          case .poweredOff:
            print("peripheral.state is .poweredOff")
          case .poweredOn:
            print("peripheral.state is .poweredOn")
            peripheralManager.add(likeUService)
            peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[BLEModels.serviceUUID]])
            
          default:
            print("Unknown error for PeripheralManger.state")
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {
        // Just for using background
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?){
        for service in peripheral.services ?? []{
            if service.uuid == BLEModels.serviceUUID{
                if !(checkedPeripherals.contains(peripheral)){
                    checkedPeripherals.append(peripheral)
                    newCompanion.peripheral = peripheral
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service:CBService, error: Error?){
        for characteristic in service.characteristics ?? []{
            if characteristic.uuid == BLEModels.userInfoUUID {
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.readValue(for: characteristic)
            }
            if characteristic.uuid == BLEModels.descriptionUUID{
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.readValue(for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        switch characteristic.uuid {
        case BLEModels.userInfoUUID:
            let nameDataStr = String(data: characteristic.value!, encoding: .utf8)
            userTitles.append(nameDataStr!)
            usersList.reloadData()
            newCompanion.firstName = nameDataStr!
            print ("User info: \(String(describing: nameDataStr)))")
        case BLEModels.descriptionUUID:
            let descrDataStr = String(data: characteristic.value!, encoding: .utf8)
            newCompanion.description = descrDataStr!
            companions.append(newCompanion)
            print ("Companion added")
            print ("\(companions.count)")
            usersList.reloadData()
        default:
            print("Unknown characteristic")
        }
    }
}
