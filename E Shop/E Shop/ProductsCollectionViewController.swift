//
//  ProductsCollectionViewController.swift
//  E Shop
//
//  Created by Daniel Urumov on 18.01.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

private let catalog_url = Bundle.main.url(forResource: "catalog", withExtension: "json")!

class ProductsCollectionViewController: UICollectionViewController {
    
    var catalog: Catalog? = nil {
        didSet {
            cells = catalog?.productsIds.map {ProductCell(id: $0)} ?? []
        }
    }
    
    var cells: [ProductCell] = [] {
        didSet {
            collectionView!.reloadData()
        }
    }
    
    private func loadCatalog() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let json = try? Data(contentsOf: catalog_url) else {
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
        let nib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        collectionView!.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCatalog()
        
        registerCell()
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cells.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
            ) as! ProductCollectionViewCell
        
        return cells[indexPath.row].setView(view: cellView, catalog: catalog)
    }
}


