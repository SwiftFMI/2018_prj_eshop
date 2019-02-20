//
//  ProductDetailViewViewController.swift
//  E Shop
//
//  Created by Daniel Urumov on 18.02.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    var product: Product!
    
    var cart: Cart!
    
    var cartBarButtonItem: UIBarButtonItem! {
        didSet {
            navigationItem.setRightBarButton(cartBarButtonItem, animated: false)
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.hidesWhenStopped = true
        }
    }
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var priceView: UILabel! {
        didSet {
            priceView.layer.cornerRadius = priceView.frame.width / 2
            priceView.layer.masksToBounds = true
            priceView.backgroundColor = green
            priceView.textColor = .white
        }
    }
    
    @IBOutlet weak var conditionView: UILabel!
    
    @IBOutlet weak var colorView: UILabel!
    
    @IBOutlet weak var cartAddButton: UIButton! {
        didSet {
            cartAddButton.backgroundColor = green
            cartAddButton.layer.cornerRadius = cartAddButton.frame.width / 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initView()
    }
    
    @IBAction func addProductInCart() {
        cart.addProduct(id: product.id)
    }
    
    private func initView() {
        titleView.text = "  " + product.title
        priceView.text = "$" + product.price
        colorView.text = product.color
        conditionView.text = product.condition
        
        spinner?.startAnimating()
        loadFirstImage(view: imageView, product: product) { [weak self] in
            self?.spinner?.stopAnimating()
        }
    }
}
