//
//  CoreDataSession.swift
//  ILikeU
//
//  Created by George Gostev on 03/04/2020.
//  Copyright © 2020 George Gostev. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class CoreDataSession {
    
    let profile = Profile.shared
    
    func SaveUserData (name: String, description: String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let user = NSEntityDescription.insertNewObject(forEntityName: "UserCoreData", into: context)
        
        user.setValue(name, forKey: "firstName")
        user.setValue(description, forKey: "userDescription")
        
        do {
            try context.save()
            print("saved")
        } catch {
            
        }
        
    }
    
    func SaveUserAvatar (avatar: UIImage){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let user = NSEntityDescription.insertNewObject(forEntityName: "UserCoreData", into: context)
        
        let avatarJPG = avatar.jpegData(compressionQuality: 1.0)
        
        user.setValue(avatarJPG, forKey: "avatar")
        
        do {
            try context.save()
            print("saved")
        } catch {
            
        }
    }
    
    func getUserData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCoreData")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let firstName = result.value(forKey: "firstName") as? String {
                        self.profile.user.firstName = firstName
                    }
                    
                    if let description = result.value(forKey: "userDescription") as? String {
                        self.profile.user.description = description
                    }
                    
                    if let avatar = result.value(forKey: "avatar") as? Data {
                        self.profile.user.profilePhoto = UIImage(data: avatar as Data)
                    }
                    
                }
            } else {
                print("cannot get user Data")
            }
        } catch {
            
        }
        
    }
    
    static let shared = CoreDataSession()
    
    private init() {
        
    }
}
