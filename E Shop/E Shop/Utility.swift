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
    loadFirstImage(view: view.photoView, product: product)
}

func loadFirstImage(view: UIImageView, product: Product, completion: (() -> Void)? = nil) {
    view.accessibilityIdentifier = nil
    view.image = product.images.first?.image
    
    if product.images.first?.image == nil && !product.images.isEmpty {
        loadImage(view: view, product: product, imageIndex: 0, completion: completion)
    } else {
        completion?()
    }
}

func loadImage(view: UIImageView, product: Product, imageIndex: Int, completion: (() -> Void)? = nil) {
    let resource = product.images[imageIndex].resource
    
    if let image = UIImage(named: resource, in: Bundle.main, compatibleWith: view.traitCollection) {
        view.image = image
        product.images[imageIndex].image = image
        completion?()
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
    } else {
        completion?()
    }
}

func initView(productId: String, view: OrderProductViewCell, cart: Cart, catalog: Catalog) {
    let product = catalog[productId]
    view.titleView.text = product.title
    view.priceView.text = "$" + product.price
    view.countView.text = "\(cart[productId])x"
}

func initView(view: OrderTotalViewCell, cart: Cart, catalog: Catalog) {
    view.priceView.text = cart.totalPrice(catalog: catalog).toPrice
}

extension UInt {
    var toPrice: String{
        return "$\(Float(self) / 100)"
    }
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

extension Set {
    mutating func insert(_ newMembers: [Set.Element]) -> Set<Element> {
        newMembers.forEach {
            self.insert($0)
        }
        return self
    }
}

func sentOrderMail(cart: Cart, userEmail: String, phone: String, shippingAddress: String, _ callback: @escaping (Error?) -> Void) {
    let eshopEmail = "eshopios2019@gmail.com" //password = "ios2019eshop"
    let sender = "eshop2019@mail.bg"
    
    let smtpSession = MCOSMTPSession()
    smtpSession.hostname = "smtp.mail.bg"
    smtpSession.username = sender
    smtpSession.password = "daniboybye"
    smtpSession.port = 465
    smtpSession.authType = .saslPlain
    smtpSession.connectionType = .TLS
    smtpSession.connectionLogger = {(connectionID, type, data) in
        if let data = data, let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            print("Connectionlogger: \(string)")
        }
    }
    
    let builder = MCOMessageBuilder()
    builder.header.to = [MCOAddress(displayName: "Server", mailbox: eshopEmail)]
    builder.header.from = MCOAddress(displayName: "Client", mailbox: sender)
    builder.header.subject = "Order"
    builder.htmlBody = [
        "email: \(userEmail)",
        "phone: \(phone)",
        "shipping address: \(shippingAddress)",
        "contents:",
        cart.productsId.map {"\tproduct id: \($0) - count: \(cart[$0])"} .joined(separator: "\r\n")
    ].joined(separator: "\r\n")
    
    smtpSession.sendOperation(with: builder.data())?.start(callback)
}

//https://stackoverflow.com/questions/25919472/adding-a-closure-as-target-to-a-uibutton
class ClosureSleeve {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
