//
//  UserProfileController.swift
//  ILikeU
//
//  Created by George Gostev on 10/04/2020.
//  Copyright © 2020 George Gostev. All rights reserved.
//

import Foundation
import CoreData
import CoreBluetooth
import MultipeerConnectivity
import UIKit

class UserProfileController: UIViewController{
    
    var userDescription = ""
    var userName = ""
    var userPhoto = UIImage(named: "profile")
    var userPeripheral: CBPeripheral?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = userName
        descriptionLabel.text = userDescription
        imageView.image = userPhoto
        
    }
    
    @IBAction func ButtonTapped(_sender: UIButton){
        
    }
    
}
