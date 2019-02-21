//
//  OrderShippingDataViewCell.swift
//  E Shop
//
//  Created by Daniel Urumov on 21.02.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

class OrderShippingDataViewCell: UICollectionViewCell {
    @IBOutlet weak var fullNameView: UITextField!
    
    @IBOutlet weak var emailView: UITextField!
    
    @IBOutlet weak var phoneView: UITextField!
    
    @IBOutlet weak var addressView: UITextField! {
        didSet {
            //placeholder on top
        }
    }
    
    @IBOutlet weak var sendOrderButton: UIButton! {
        didSet {
            sendOrderButton.backgroundColor = green
        }
    }
}
