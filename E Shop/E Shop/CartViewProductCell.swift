//
//  CartViewProductCell.swift
//  E Shop
//
//  Created by Daniel Urumov on 19.02.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

class CartViewProductCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var priceView: UILabel! {
        didSet {
            priceView.textColor = green
        }
    }
    
    @IBOutlet weak var countView: UILabel!
    
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var minusButton: UIButton!
    
    @IBOutlet weak var removeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
