//
//  OrderProductViewCell.swift
//  E Shop
//
//  Created by Daniel Urumov on 21.02.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

class OrderProductViewCell: UICollectionViewCell {
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var countView: UILabel!
    
    @IBOutlet weak var priceView: UILabel!
}

func initView(productId: String, view: OrderProductViewCell, cart: Cart, catalog: Catalog) {
    let product = catalog[productId]
    view.titleView.text = product.title
    view.priceView.text = "$" + product.price
    view.countView.text = "\(cart[productId])x"
}
