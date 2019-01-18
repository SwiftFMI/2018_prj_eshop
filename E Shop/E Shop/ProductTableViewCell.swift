//
//  ProductTableViewCell.swift
//  E Shop
//
//  Created by Daniel Urumov on 17.01.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var descriptionView: UILabel! {
        didSet {
             descriptionView.font = UIFont(name: descriptionView.font.fontName, size: 5)
        }
    }
    
    @IBOutlet weak var priceView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
