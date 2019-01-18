//
//  ProductsTableViewController.swift
//  E Shop
//
//  Created by Daniel Urumov on 17.01.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

class ProductCell {
    let id: String
    
    init(id: String) {
        self.id = id
    }
    
    func setView(view: ProductTableViewCell, catalog: Catalog?) -> ProductTableViewCell {
        if let product = catalog?.getProduct(id: id) {
            view.titleView?.text = product.title
            view.descriptionView?.text = product.description
            view.priceView?.text = product.price
        }
        return view
    }
}

class ProductsTableViewController: UITableViewController {
    
    static let catalog_url = Bundle.main.url(forResource: "catalog", withExtension: "json")!
    
    var catalog: Catalog? = nil {
        didSet {
            self.cells = catalog?.productsIds.map {ProductCell(id: $0)} ?? []
        }
    }
    var cells: [ProductCell] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private func loadCatalog() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let json = try? Data(contentsOf: ProductsTableViewController.catalog_url) else {
                print("invalid json url")
                return
            }
            guard let catalog = try? JSONDecoder().decode(Catalog.self, from: json) else {
                print("invalid json format")
                return
            }
            DispatchQueue.main.async {
                self?.catalog = catalog
            }
        }
    }
    
    
    private func registerCell() {
        let textFieldCell = UINib(nibName: "ProductTableViewCell", bundle: nil)
        tableView.register(textFieldCell, forCellReuseIdentifier: "ProductTableViewCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCatalog()
        
        registerCell()
        
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellView = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        
        return cells[indexPath.row].setView(view: cellView, catalog: catalog)
    }

}
