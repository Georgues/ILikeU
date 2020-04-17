//
//  ChatsViewController.swift
//  ILikeU
//
//  Created by George Gostev on 03/04/2020.
//  Copyright © 2020 George Gostev. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit
import MultipeerConnectivity
import CoreData

class ChatsViewController: UICollectionViewController{
    
    static var chats: [Chat] = []
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwipeObserver()
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: "cellId")
        SetupCollectionView()
        collectionView.alwaysBounceVertical = true
    }

    func SwipeObserver (){
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(Swipes))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(Swipes))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    @objc func Swipes(gester: UISwipeGestureRecognizer){
        switch gester.direction {
        case .left:
            performSegue(withIdentifier: "ProfileSegue", sender: nil)
        case .right:
            performSegue(withIdentifier: "BackToMap", sender: nil)
        default:
            return
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ChatsViewController.chats.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
    }
    
    func SetupCollectionView(){
        let cellSize = CGSize(width:view.frame.width , height:100)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 0, right: 0)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        collectionView.setCollectionViewLayout(layout, animated: true)

        collectionView.reloadData()
    }

}
