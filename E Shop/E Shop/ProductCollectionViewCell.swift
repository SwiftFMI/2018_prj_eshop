//
//  ProductCollectionViewCell.swift
//  E Shop
//
//  Created by Daniel Urumov on 18.01.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    static let height = CGFloat(150)
    
    var product_id: String!
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var descriptionView: UILabel! {
        didSet {
            descriptionView.font = UIFont(name: descriptionView.font.fontName, size: 8)
            descriptionView.textColor = .gray
        }
    }
    
    @IBOutlet weak var priceView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
