//
//  ChatCell.swift
//  ILikeU
//
//  Created by George Gostev on 13/04/2020.
//  Copyright © 2020 George Gostev. All rights reserved.
//

import Foundation
import UIKit

class ChatCell: UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        SetupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func SetupViews(){
        backgroundColor = UIColor.red
    }
    
}
