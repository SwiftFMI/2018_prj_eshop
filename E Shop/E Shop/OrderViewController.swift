//
//  OrderViewController.swift
//  E Shop
//
//  Created by Daniel Urumov on 21.02.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

private let reuseIdentifiers = ["OrderProductViewCell", "OrderTotalViewCell", "OrderShippingDataViewCell"]

class OrderViewController: UICollectionViewController {
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
    
    private var productsId: [String] = []
    
    private var catalog: Catalog {
        get {
            return model.catalog
        }
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
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? cart.productKindsCount : 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifiers[indexPath.section], for: indexPath)
    
        switch indexPath.section {
        case 0:
            initView(
                productId: productsId[indexPath.row],
                view: cell as! OrderProductViewCell,
                cart: cart,
                catalog: catalog
            )
        case 1:
            initView(
                view: cell as! OrderTotalViewCell,
                cart: cart,
                catalog: catalog
            )
        case 2:
            initOrderView(
                view: cell as! OrderShippingDataViewCell
            )
        default:
            break
        }
    
        return cell
    }
    
    private func showMessage(view: OrderShippingDataViewCell?, message: String) {
        guard let view = view else {
            return
        }
        UIView.transition(
            with: view.headerTextView,
            duration: 2.0,
            options: .transitionCrossDissolve,
            animations: {
                view.setHeaderText(message, color: .red)
            },
            completion: { _ in
                UIView.transition(
                    with: view.headerTextView,
                    duration: 8.0,
                    options: .transitionCrossDissolve,
                    animations: {
                        view.setHeaderText()
                    }
                )
            }
        )
    }
    
    private func initOrderView(view: OrderShippingDataViewCell) {
        view.emailView.delegate = self
        view.fullNameView.delegate = self
        view.phoneView.delegate = self
        view.addressView.delegate = self
        
        view.sendOrderButton.addAction(for: .touchUpInside) { [weak view, weak self] in
            guard let fullName = view?.fullNameView.text, fullName != "" else {
                self?.showMessage(view: view, message: "Please enter your full name")
                return
            }
            guard let email = view?.emailView.text, email != "" else {
                self?.showMessage(view: view, message: "Please enter your email")
                return
            }
            guard let phone = view?.phoneView.text, phone != "" else {
                self?.showMessage(view: view, message: "Please enter your phone number")
                return
            }
            guard let address = view?.addressView.text, address != "" else {
                self?.showMessage(view: view, message: "Please enter your address or comment")
                return
            }
            DispatchQueue.global(qos: .userInitiated).async {
                guard let cart = self?.cart else {
                    return
                }
                sentOrderMail(cart: cart, name: fullName, userEmail: email, phone: phone, shippingAddress: address) { error in
                    DispatchQueue.main.async {
                        guard let button = view?.sendOrderButton else {
                            return
                        }
                        UIView.animate(withDuration: 3.0) {
                            if let error = error {
                                print("send main error: \(error)")
                                button.backgroundColor = .red
                                button.setTitle("Try again", for: .normal)
                            } else {
                                button.isEnabled = false
                                button.setTitle("Successfully", for: .normal)
                            }
                            button.setNeedsLayout()
                        }
                    }
                }
            }
        }
    }
}

extension OrderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height: CGFloat
        switch indexPath.section {
        case 0:
            height = 50
        case 1:
            height = 75
        case 2:
            height = 340
        default:
            height = 0
        }
        
        return CGSize(
            width: collectionView.frame.size.width,
            height: height
        )
    }
}

extension OrderViewController: UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        //textField.resignFirstResponder()
//        textField.endEditing(true)
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
