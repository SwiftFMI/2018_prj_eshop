//
//  Product.swift
//  E Shop
//
//  Created by Daniel Urumov on 16.01.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import Foundation
import UIKit

final class Catalog: Decodable {
    let categories: [Category]
    let sliderProducts: [Product]
    let tableProducts: [Product]
    let products: [Product]
    private let productsDictionary: [String: Int]
    private let categoriesDictionary: [String: Int]
    
    subscript(product_id: String) -> Product {
        return products[productsDictionary[product_id]!]
    }
    
    func getCategory(id: String) -> Category {
        return categories[categoriesDictionary[id]!]
    }
    
    enum MyStructKeys: String, CodingKey {
        case categories
        case slider
        case products
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyStructKeys.self)
        categories = try container.decode([Category].self, forKey: .categories)
        sliderProducts = try container.decode([Product].self, forKey: .slider)
        tableProducts = try container.decode([Product].self, forKey: .products)
        products = sliderProducts + tableProducts
        productsDictionary = Dictionary(
            uniqueKeysWithValues: zip(products.map {($0.id)}, 0..<products.count)
        )
        categoriesDictionary = Dictionary(
            uniqueKeysWithValues: zip(categories.map {($0.id)}, 0..<categories.count)
        )
    }
}

struct Category: Codable {
    let id: String
    let parentId: String?
    let title: String
}

final class Product: Decodable {
    let id: String
    let category: String
    let price: String
    let discount: String
    let date: String
    let title: String
    let description: String
    let condition: String
    let color: String
    var images: [(image: UIImage?, resource: String)]
    
    enum MyStructKeys: String, CodingKey {
        case id
        case category
        case price
        case discount
        case date
        case title
        case photos
        case description
        case condition
        case color
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyStructKeys.self)
        id = try container.decode(String.self, forKey: .id)
        category = try container.decode(String.self, forKey: .category)
        price = try container.decode(String.self, forKey: .price)
        discount = try container.decode(String.self, forKey: .discount)
        date = try container.decode(String.self, forKey: .date)
        title = try container.decode(String.self, forKey: .title)
        images = ((try container.decode([String:[String]].self, forKey: .photos))["photo"] ?? [])
            .map {(image: nil, resource: $0)}
        description = try container.decode(String.self, forKey: .description)
        condition = try container.decode(String.self, forKey: .condition)
        color = try container.decode(String.self, forKey: .color)
    }
}

extension Product: Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Product: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
