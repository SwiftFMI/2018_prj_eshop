//
//  CartViewController.swift
//  E Shop
//
//  Created by Daniel Urumov on 19.02.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

private let reuseIdentifiers = ["CartViewProductCell", "CartSummaryCollectionViewCell"]

class CartViewController: UICollectionViewController {
    @IBOutlet var checkoutButton: UIButton!
    
    private var model: (cart: Cart, catalog: Catalog)! {
        didSet {
            productsId = cart.productsId
        }
    }
    
    private var cart: Cart {
        get {
            return model.cart
        }
    }
    
    private var catalog: Catalog {
        get {
            return model.catalog
        }
    }
    
    private var productsId: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private func reloadAfterCountUpdate(indexPath: IndexPath) {
        checkoutButton.isHidden = cart.isEmpty
        collectionView.reloadItems(at: [indexPath])
        collectionView.reloadSections(IndexSet(1...1))
    }
    
    private func addProduct(indexPath: IndexPath, id: String) {
        guard indexPath.row < productsId.count, productsId[indexPath.row] == id else {
            return
        }
        cart.addProduct(id: productsId[indexPath.row])
        reloadAfterCountUpdate(indexPath: indexPath)
    }
    
    private func decrementProductCount(indexPath: IndexPath, id: String) {
        guard indexPath.row < productsId.count, productsId[indexPath.row] == id else {
            return
        }
        cart.decrementProductCount(id: productsId[indexPath.row])
        reloadAfterCountUpdate(indexPath: indexPath)
    }
    
    func setModel(cart: Cart, catalog: Catalog) {
        model = (cart, catalog)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reuseIdentifiers.forEach {
            collectionView.register(
                UINib(nibName: $0, bundle: nil),
                forCellWithReuseIdentifier: $0
            )
        }
        
        navigationItem.setRightBarButton(UIBarButtonItem(customView: checkoutButton), animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkoutButton.isHidden = cart.isEmpty
    }
    
    @IBAction func checkout() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let orderViewController = storyboard.instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
        orderViewController.setModel(cart: cart, catalog: catalog)
        navigationController!.pushViewController(orderViewController, animated: true)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? productsId.count : 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifiers[indexPath.section], for: indexPath)
    
        if indexPath.section == 0 {
            initView(indexPath: indexPath, view: cell as! CartViewProductCell)
        } else if indexPath.section == 1 {
            initView(view: cell as! CartSummaryCollectionViewCell)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        cart.removeProduct(id: productsId[indexPath.row])
        productsId.remove(at: indexPath.row)
        checkoutButton.isHidden = cart.isEmpty
        //collectionView.deleteItems(at: [indexPath])
        collectionView.reloadData()
    }
    
    private func initView(indexPath: IndexPath, view: CartViewProductCell) {
        let index = indexPath.row
        let id = productsId[index]
        let product = catalog[id]
        let count = cart[id]
        view.plusButton.addAction(for: .touchUpInside) { [weak self] in
            self?.addProduct(indexPath: indexPath, id: id)
        }
        view.minusButton.addAction(for: .touchUpInside) { [weak self] in
            self?.decrementProductCount(indexPath: indexPath, id: id)
        }
        view.deleteButton.isEnabled = false
        view.isHiddenCountsView = false
        view.minusButton.isHidden = count == 0
        view.countView.text = String(count)
        view.titleView.text = product.title
        view.priceView.text = "$" + product.price
        loadFirstImage(view: view.imageView, product: product)
    }
    
    private func initView(view: CartSummaryCollectionViewCell) {
        let totalPrice = cart.totalPrice(catalog: catalog)
        let vat = UInt(Float(totalPrice) * 0.2)
        view.savedView.text = "$0.0"
        view.vatView.text = vat.toPrice
        view.subtotalView.text = (totalPrice - vat).toPrice
        view.totalView.text = totalPrice.toPrice
    }
}

extension CartViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        //let height = collectionViewLayout.layoutAttributesForItem(at: indexPath)!.frame.size.height
        let height: CGFloat = indexPath.section == 0 ? 100 : 250
        return CGSize(width: width, height: height)
    }
}
