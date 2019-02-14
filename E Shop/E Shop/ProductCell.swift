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
    let product: Product
    
    private var images: [UIImage]! //images is nil only before first call setView
    
    init(product: Product) {
        self.product = product
    }
    
    func setView(view: ProductCollectionViewCell) {
        view.product_id = product.id
        view.titleView.text = product.title
        view.descriptionView.text = product.description
        view.priceView.text = "$" + product.price
        view.photoView.image = images?.first
            
        if images == nil {
            images = []
            loadTopImage(view: view)
        }
    }
    
    private func loadTopImage(view: ProductCollectionViewCell) {
        guard let image_name = product.images.first else {
            return
        }
        if let image = UIImage(named: image_name, in: Bundle.main, compatibleWith: view.photoView.traitCollection) {
            view.photoView.image = image
            images.append(image)
        } else if let url = URL(string: image_name) {
            DispatchQueue.global(qos: .userInitiated).async { [weak self, weak view] in
                guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    self.images.append(image)
                    
                    if let view = view, view.product_id == self.product.id, view.photoView.image == nil {
                        view.photoView.image = image
                        view.photoView.setNeedsDisplay()
                    }
                }
            }
        }
    }
}
