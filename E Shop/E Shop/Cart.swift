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
    
    private func defaultValue() -> (count: UInt, orderId: UInt) {
        nextOrderId += 1
        return (count: 0, orderId: nextOrderId)
    }
    
    private var productsDict = Dictionary<String, (count: UInt, orderId: UInt)>()
    
    func addProduct(id: String) {
        var value = productsDict[id, default: defaultValue()]
        value.count += 1
        productsDict[id] = value
        delegate?.updateProducts(count: productsDict.count)
    }
    
    func removeProduct(id: String) {
        productsDict[id] = nil
        delegate?.updateProducts(count: productsDict.count)
    }
    
    func decrementProductCount(id: String) {
        let (count, _) = productsDict[id]!
        if count == 1 {
            removeProduct(id: id)
        } else {
            productsDict[id]!.count = count - 1
        }
    }
    
    var product: [(id: String, count: UInt)] {
        get {
            return productsDict.sorted { $0.value.orderId < $1.value.orderId}
                .map {(id: $0.key, count: $0.value.count)}
        }
    }
}
