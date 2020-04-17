//
//  ChatViewController.swift
//  ILikeU
//
//  Created by George Gostev on 03/04/2020.
//  Copyright © 2020 George Gostev. All rights reserved.
//

import Foundation
import CoreBluetooth
//import MultipeerConnectivity
import UIKit

class ChatViewController: UIViewController{
    
    @IBOutlet var inputTextView: UITextView!
    @IBOutlet var sendButton: UIButton!
    var chat: Chat?
    var companion: Companion?
    let profile = Profile.shared
    let sendInfoCharacteristic = CBMutableCharacteristic(type: BLEModels.sendInfoUUID, properties: .write, value: BLEModels.sendData, permissions: .writeable)
    
    
    @IBAction func sendMessage(_sender: Any){
        SendMessage(peripheral: companion!.peripheral, text: inputTextView.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chat!.companion = companion
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    
    func SendMessage(peripheral: CBPeripheral?, text: String?){
        let message = Message()
        message.author = profile.user.firstName
        message.text = text
        chat?.messages.append(message)
        ChatsViewController.chats.append(chat!)
        
        if let messageData = text!.data(using: .utf8){
            companion?.peripheral?.writeValue(messageData, for: sendInfoCharacteristic, type: .withResponse)
        }
        
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
}


