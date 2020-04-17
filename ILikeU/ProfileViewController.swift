//
//  ProfileViewController.swift
//  ILikeU
//
//  Created by George Gostev on 03/04/2020.
//  Copyright © 2020 George Gostev. All rights reserved.
//

import Foundation
import CoreData
import CoreBluetooth
import MultipeerConnectivity
import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let profile = Profile.shared
    let coreData = CoreDataSession.shared
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameEdit: UITextField!
    @IBOutlet weak var descriptionEdit: UITextField!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonTapped(_ sender: Any) {
        EditInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameEdit.isHidden = true
        descriptionEdit.isHidden = true
        
        UpdateInfo()
        
        SwipeObserver()
        TapObserver()
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameLabel.text = profile.user.firstName
        labelView.text = profile.user.description
        imageView.image = profile.user.profilePhoto
    }
    
    @objc func kbDidShow(notification: Notification){
        guard let userInfo = notification.userInfo else {return}
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= kbFrameSize.height
        }
    }
    
    @objc func kbDidHide(notification: Notification){
        
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
    }
    
    func SwipeObserver (){
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(Swipes))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    func TapObserver (){
        
        let photoTap = UITapGestureRecognizer(target: self, action: #selector(TapOnPhoto))
//        self.view.addGestureRecognizer(photoTap)
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(photoTap)
    }
    
    @objc func TapOnPhoto(touch: UITapGestureRecognizer){
        print ("Tapped")
        let ac = UIAlertController(title: "Добавить новое фото", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Сделать новое фото", style: .default, handler: {(action) in
            self.chooseImagePickerAction(source: .camera)
        })
        let galeryAction = UIAlertAction(title: "Добавить фото из галереи", style: .default, handler: {(action) in
            self.chooseImagePickerAction(source: .photoLibrary)
        })
        let cancel = UIAlertAction(title: "Назад", style: .cancel, handler: {(action) in})
        ac.addAction(cameraAction)
        ac.addAction(galeryAction)
        ac.addAction(cancel)
        
        self.present(ac, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        profile.user.profilePhoto = profileImage
        imageView.image = profileImage
        coreData.SaveUserAvatar(avatar: profileImage)
        
        dismiss(animated: true, completion: nil)
    }
    
    func chooseImagePickerAction (source: UIImagePickerController.SourceType){
        
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func UpdateInfo(){
        if profile.user.firstName != "null" {
            nameLabel.text = profile.user.firstName
        } else {
            nameLabel.text = "Name"
        }
        if profile.user.description != "null" {
            labelView.text = profile.user.description
        } else{
            labelView.text = "Description"
        }
        if  let image = profile.user.profilePhoto {
            imageView.image = image
        }
    }
    
    @objc func Swipes(gester: UISwipeGestureRecognizer){
        if gester.direction == .right {
            performSegue(withIdentifier: "BackToChats", sender: nil)
        }
    }
    
    func EditInfo(){
        
        if button.restorationIdentifier == "Edit" {
            button.restorationIdentifier = "Save"
            nameEdit.text = nameLabel.text
            descriptionEdit.text = labelView.text
            labelView.isHidden = true
            descriptionEdit.isHidden = false
            nameLabel.isHidden = true
            nameEdit.isHidden = false
            button.setTitle("Сохранить", for: .normal)
        } else if button.restorationIdentifier == "Save" {
            button.restorationIdentifier = "Edit"
            if nameEdit.text != ""{
                nameLabel.text = nameEdit.text
                profile.user.firstName = nameEdit.text!
            }
            labelView.text = descriptionEdit.text
            profile.user.description = descriptionEdit.text!
            labelView.isHidden = false
            descriptionEdit.isHidden = true
            nameLabel.isHidden = false
            nameEdit.isHidden = true
            button.setTitle("Изменить информацию о себе", for: .normal)
            coreData.SaveUserData(name: profile.user.firstName, description: profile.user.description)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
