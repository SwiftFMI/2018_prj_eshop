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
    
    weak var view: ProductCollectionViewCell? = nil
    
    var images: [UIImage]! = nil //images is nil only before first call setView
    
    init(id: String) {
        self.id = id
    }
    
    func setView(view: ProductCollectionViewCell, catalog: Catalog?) -> ProductCollectionViewCell {
        if let product = catalog?.getProduct(id: id) {
            
            self.view = view
            view.photoView?.image = images?.first
            
            if images == nil {
                images = []
                loadTopImage(product: product)
            }
            
            view.titleView?.text = product.title
            view.descriptionView?.text = product.description
            view.priceView?.text = product.price + "$"
        }
        return view
    }
    
    private func loadTopImage(product: Product) -> Void {
        if let name = product.images.first {
            if let image = UIImage(named: name, in: Bundle.main, compatibleWith: view!.photoView!.traitCollection) {
                view?.photoView!.image = image
                images.append(image)
            } else if let url = URL(string: name) {
                DispatchQueue.global(qos: .userInitiated).async { [weak self, title = product.title] in
                    guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                        return
                    }
                    DispatchQueue.main.async {
                        if let view = self?.view , view.titleView?.text == title {
                            view.photoView!.image = image
                            view.photoView!.setNeedsDisplay()
                            self?.images.append(image)
                        }
                    }
                }
            }
        }
    }
}
