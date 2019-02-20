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
    
    private var productsId: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
//    private func removeProduct(indexPath: IndexPath, id: String) {
//        guard indexPath.row < productsId.count, productsId[indexPath.row] == id else {
//            return
//        }
//        model.cart.removeProduct(id: productsId[indexPath.row])
//        productsId.remove(at: indexPath.row)
//        collectionView.reloadData()
//    }
    
    private func reloadAfterCountUpdate(indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
        collectionView.reloadSections(IndexSet(1...1))
    }
    
    private func addProduct(indexPath: IndexPath, id: String) {
        guard indexPath.row < productsId.count, productsId[indexPath.row] == id else {
            return
        }
        model.cart.addProduct(id: productsId[indexPath.row])
        reloadAfterCountUpdate(indexPath: indexPath)
    }
    
    private func decrementProductCount(indexPath: IndexPath, id: String) {
        guard indexPath.row < productsId.count, productsId[indexPath.row] == id else {
            return
        }
        model.cart.decrementProductCount(id: productsId[indexPath.row])
        reloadAfterCountUpdate(indexPath: indexPath)
    }
    
    func setModel(cart: Cart, catalog: Catalog) {
        self.model = (cart, catalog)
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
    
    @IBAction func checkout() {
        
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
        model.cart.removeProduct(id: productsId[indexPath.row])
        productsId.remove(at: indexPath.row)
        //collectionView.deleteItems(at: [indexPath])
        collectionView.reloadData()
    }
    
    private func initView(indexPath: IndexPath, view: CartViewProductCell) {
        let index = indexPath.row
        let id = productsId[index]
        let product = model.catalog[id]
        let count = model.cart[id]
        view.plusButton.addAction(for: .touchUpInside) { [weak self] in
            self?.addProduct(indexPath: indexPath, id: id)
        }
        view.minusButton.addAction(for: .touchUpInside) { [weak self] in
            self?.decrementProductCount(indexPath: indexPath, id: id)
        }
        view.minusButton.isHidden = count == 0
        view.countView.text = String(count)
        view.titleView.text = product.title
        view.priceView.text = "$" + product.price
        loadFirstImage(view: view.imageView, product: product)
    }
    
    private func initView(view: CartSummaryCollectionViewCell) {
        let totalPrice = UInt(productsId.map {
            let product = model.catalog[$0]
            return Double(product.price.floatValue * Float(model.cart[$0]))
        }.reduce(0.0, +) * 100.0)
        let vat = UInt(Float(totalPrice) * 0.2)
        view.savedView.text = "$0.0"
        view.vatView.text = toPrice(vat)
        view.subtotalView.text = toPrice(totalPrice - vat)
        view.totalView.text = toPrice(totalPrice)
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
