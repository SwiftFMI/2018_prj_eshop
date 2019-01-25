//
//  Product.swift
//  E Shop
//
//  Created by Daniel Urumov on 16.01.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import Foundation

final class Catalog {
    private let categories: [Category]
    private let all_products: [Product]
    private let slider: [String: Int] // id => index in all_products
    private let products: [String: Int] // id => index in all_products
    private let categories_index: [String: Int] // id => index in categories
    
    var productsIds: [String] {
        get {
            return Array(products.keys)
        }
    }
    
    var sliderIds: [String] {
        get {
            return Array(slider.keys)
        }
    }
    
    func getProduct(id: String) -> Product? {
        if let index = products[id] ?? slider[id] {
            return all_products[index]
        }
        return nil
    }
    
//    var products_for_slider {
//        get {
//
//        }
//    }
    
    private init(_ categories: [Category], _ slider: [Product], _ products: [Product]) {
        self.categories = categories
        self.all_products = slider + products
        self.slider = Dictionary(uniqueKeysWithValues: zip(slider.map {$0.id}, 0..<slider.count))
        self.products = Dictionary(uniqueKeysWithValues: zip(products.map {$0.id}, slider.count..<slider.count + products.count))
        self.categories_index = Dictionary(uniqueKeysWithValues: zip(categories.map {$0.id}, 0..<categories.count))
    }
}

extension Catalog: Decodable {
    enum MyStructKeys: String, CodingKey {
        case categories
        case slider
        case products
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyStructKeys.self)
        let categories = try container.decode([Category].self, forKey: .categories)
        let slider = try container.decode([Product].self, forKey: .slider)
        let products = try container.decode([Product].self, forKey: .products)
        self.init(categories, slider, products)
//        self.categories = categories
//        self.all_products = slider + products
//        self.slider = Dictionary(uniqueKeysWithValues: zip(slider.map {$0.id}, 0..<slider.count))
//        self.products = Dictionary(uniqueKeysWithValues: zip(products.map {$0.id}, slider.count..<slider.count + products.count))
//        self.categories_index = Dictionary(uniqueKeysWithValues: zip(categories.map {$0.id}, 0..<categories.count))
    }
}

struct Category: Codable {
    let id: String
    let parentId: String?
    let title: String
}

struct Product: Codable {
    let id: String
    let category: String
    let price: String
    let discount: String
    let date: String
    let title: String
    private let photos: [String:[String]]
    let description: String
    let condition: String
    let color: String
    
    var images: [String] {
        get {
            return photos["photo"] ?? []
        }
    }
}
