//
//  Profile.swift
//  ILikeU
//
//  Created by George Gostev on 03/04/2020.
//  Copyright © 2020 George Gostev. All rights reserved.
//

import Foundation
import CoreData

class Profile {
    
    var user = User()
    
    static let shared = Profile()
    
    private init() {
        
    }
}
