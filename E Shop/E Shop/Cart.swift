//
//  Cart.swift
//  E Shop
//
//  Created by Daniel Urumov on 15.02.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import Foundation

class Cart {
    var delegate: CartDelegate?
    
    private var products: [(id: String, count: UInt)] = [] {
        didSet {
            delegate?.updateProducts(count: products.count)
        }
    }
    
    func addProduct(id: String) {
        products.append((id: id, count: 1))
    }
}
