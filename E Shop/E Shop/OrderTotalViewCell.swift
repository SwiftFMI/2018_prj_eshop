//
//  OrderTotalViewCell.swift
//  E Shop
//
//  Created by Daniel Urumov on 21.02.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

class OrderTotalViewCell: UICollectionViewCell {
    @IBOutlet weak var priceView: UILabel!
}

func initView(view: OrderTotalViewCell, cart: Cart, catalog: Catalog) {
    view.priceView.text = cart.totalPrice(catalog: catalog).toPrice
}
