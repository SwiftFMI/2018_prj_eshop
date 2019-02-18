//
//  ProductCell.swift
//  E Shop
//
//  Created by Daniel Urumov on 18.01.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import Foundation
import UIKit

func initView(product: Product, view: ProductCollectionViewCell) {
    view.titleView.text = product.title
    view.descriptionView.text = product.description
    view.priceView.text = "$" + product.price + " "
    view.photoView.accessibilityIdentifier = nil
    view.photoView.image = product.images.first?.image
    
    if product.images.first?.image == nil && !product.images.isEmpty {
        loadImage(view: view.photoView, product: product, imageIndex: 0, completion: nil)
    }
}

func loadImage(view: UIImageView, product: Product, imageIndex: Int, completion: (() -> Void)?) {
    let resource = product.images[imageIndex].resource
    
    if let image = UIImage(named: resource, in: Bundle.main, compatibleWith: view.traitCollection) {
        view.image = image
        product.images[imageIndex].image = image
    } else if let url = URL(string: resource) {
        view.accessibilityIdentifier = resource
        DispatchQueue.global(qos: .userInitiated).async { [weak view, weak product] in
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                product?.images[imageIndex].image = image
                
                if let view = view, view.accessibilityIdentifier == resource, view.image == nil {
                    view.image = image
                    completion?()
                    view.setNeedsDisplay()
                }
            }
        }
    }
}
