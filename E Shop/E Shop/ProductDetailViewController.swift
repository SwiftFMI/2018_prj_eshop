//
//  DetailProductViewController.swift
//  E Shop
//
//  Created by Daniel Urumov on 16.02.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    var product: Product!
    
    @IBOutlet var productView: ProductDetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        print(1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        product = currProduct!
        initView(product: product, view: productView)
    }
    
    @IBAction func addProductInCart() {
        cart.addProduct(id: product.id)
    }
}
