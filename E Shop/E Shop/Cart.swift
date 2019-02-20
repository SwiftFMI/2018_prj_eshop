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
    
    private var nextOrderId = UInt(0)
    
    private(set) var count = UInt(0) {
        didSet {
            delegate?.updateProducts(count: count)
        }
    }
    
    private func defaultValue() -> (count: UInt, orderId: UInt) {
        nextOrderId += 1
        return (count: 0, orderId: nextOrderId)
    }
    
    private var products = Dictionary<String, (count: UInt, orderId: UInt)>()
    
    func addProduct(id: String) {
        var value = products[id, default: defaultValue()]
        value.count += 1
        products[id] = value
        count += 1
    }
    
    func removeProduct(id: String) {
        let (count, _) = products[id] ?? (0, 0)
        products[id] = nil
        self.count -= count
    }
    
    func decrementProductCount(id: String) {
        guard let (count, _) = products[id] else{
            return
        }
        if count == 1 {
            removeProduct(id: id)
        } else {
            products[id]!.count = count - 1
            self.count -= 1
        }
    }
    
    subscript(id: String) -> UInt {
        return products[id]?.count ?? 0
    }
    
    var productsId: [String] {
        get {
            return products.sorted { $0.value.orderId < $1.value.orderId} .map {$0.key}
        }
    }
}
