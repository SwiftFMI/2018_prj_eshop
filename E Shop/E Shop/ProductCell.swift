//
//  ProductCell.swift
//  E Shop
//
//  Created by Daniel Urumov on 18.01.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import Foundation
import UIKit

class ProductCell {
    let id: String
    
    init(id: String) {
        self.id = id
    }
    
    func setView(view: ProductCollectionViewCell, catalog: Catalog?) -> ProductCollectionViewCell {
        if let product = catalog?.getProduct(id: id) {
            view.titleView?.text = product.title
            view.descriptionView?.text = product.description
            view.priceView?.text = product.price
        }
        return view
    }
}
