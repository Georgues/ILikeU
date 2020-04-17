//
//  ViewController.swift
//  ILikeU
//
//  Created by George Gostev on 31/03/2020.
//  Copyright © 2020 George Gostev. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
import CoreData
import L2Cap

class MapViewController: UIViewController, StreamDelegate {
    
    let coreData = CoreDataSession.shared
    let profile = Profile.shared
    var newCompanion = Companion()
    
    @IBOutlet var usersList: UITableView!
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        
    }
    
    var i=0;
    var profileImage: UIImage?
    var availablePeripherals: [CBPeripheral] = []
    var checkedPeripherals: [CBPeripheral] = []
    var companions: [Companion] = []
    var userTitles: [String] = []
    var centralManager: CBCentralManager!
    var peripheralManager: CBPeripheralManager!
    var characteristic: CBMutableCharacteristic?
    var subscribedCentrals = [CBCharacteristic:[CBCentral]]()
    let likeUService = CBMutableService(type: BLEModels.serviceUUID, primary: true)
    let userInfoCharacteristic = CBMutableCharacteristic(type: BLEModels.userInfoUUID, properties: .read, value: BLEModels.nameData, permissions: .readable)
    let userDescriptionCharacteristic = CBMutableCharacteristic(type: BLEModels.descriptionUUID, properties: .read, value: BLEModels.descriptionData, permissions: .readable)
    let sendInfoCharacteristic = CBMutableCharacteristic(type: BLEModels.sendInfoUUID, properties: .write, value: BLEModels.sendData, permissions: .writeable)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreData.getUserData()
        SwipeObserver()
        userInfoCharacteristic.value = profile.user.firstName.data(using: .utf8)
        userDescriptionCharacteristic.value = profile.user.description.data(using: .utf8)
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: [CBPeripheralManagerOptionRestoreIdentifierKey: "restore"]) // Background work
        likeUService.characteristics = [userInfoCharacteristic, userDescriptionCharacteristic, sendInfoCharacteristic]
        

    }
    
    func SwipeObserver (){
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(Swipes))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
    @objc func Swipes(gester: UISwipeGestureRecognizer){
        if gester.direction == .left {
            performSegue(withIdentifier: "ChatsSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDescriptionSegue"{
            if let indexPath = usersList.indexPathForSelectedRow{
//                print ("\(indexPath.row)")
                let dvc = segue.destination as! UserProfileController
                let user = companions[indexPath.row]
                dvc.userName = user.firstName
                dvc.userDescription = user.description
                dvc.userPeripheral = user.peripheral
            }
        }
    }
    
}

extension MapViewController: UITableViewDelegate, UITableViewDataSource{
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usersList.dequeueReusableCell(withIdentifier: "Cell")
        var cellTitle: String?
        var cellImage: UIImage?
        if companions.count > 0{
            print(indexPath.row)
            cellTitle = companions[indexPath.row].firstName
            cellImage = companions[indexPath.row].photo
            cell?.textLabel?.text = cellTitle
            cell?.imageView?.image = cellImage
        }
        return cell!
    }
    
}
