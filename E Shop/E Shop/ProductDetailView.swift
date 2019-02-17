//
//  DetailProductView.swift
//  E Shop
//
//  Created by Daniel Urumov on 16.02.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

class ProductDetailView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var priceView: UILabel! {
        didSet {
            priceView.backgroundColor = green
            priceView.layer.cornerRadius = priceView.frame.width / 2
            priceView.textColor = .white
        }
    }
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.hidesWhenStopped = true
        }
    }
    
    @IBOutlet weak var cartAddButton: UIButton! {
        didSet {
            cartAddButton.backgroundColor = green
            cartAddButton.layer.cornerRadius = cartAddButton.frame.width / 2
        }
    }
    
    @IBOutlet weak var conditionView: UILabel!
    
    @IBOutlet weak var colorView: UILabel!
}
