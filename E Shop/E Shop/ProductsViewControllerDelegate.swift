//
//  SliderDelegate.swift
//  E Shop
//
//  Created by Daniel Urumov on 16.02.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import Foundation

protocol ProductsViewControllerDelegate {
    func selectItem(products: [Product], index: Int)
}
