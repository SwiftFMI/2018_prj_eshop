//
//  CartSummaryCollectionViewCell.swift
//  E Shop
//
//  Created by Daniel Urumov on 19.02.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

class CartSummaryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var totalTextView: UILabel! {
        didSet {
            totalTextView.textColor = green
        }
    }
    
    @IBOutlet weak var savedView: UILabel!
    
    @IBOutlet weak var subtotalView: UILabel!
    
    @IBOutlet weak var vatView: UILabel!
    
    @IBOutlet weak var totalView: UILabel! {
        didSet {
            totalView.textColor = .white
            totalView.backgroundColor = green
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
