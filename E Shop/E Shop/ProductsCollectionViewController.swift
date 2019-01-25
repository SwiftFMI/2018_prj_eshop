//
//  ProductsCollectionViewController.swift
//  E Shop
//
//  Created by Daniel Urumov on 18.01.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

private let cellsNames = ["SliderViewCell", "ProductCollectionViewCell"]

private let reuseIdentifiers = ["Slider", "Cell"]

private let catalog_url = Bundle.main.url(forResource: "catalog", withExtension: "json")!

class SliderController: NSObject, UICollectionViewDataSource {
    
    private var cells: [ProductCell] = []
    
    var notCells: Bool {
        get {
            return cells.isEmpty
        }
    }
    
    var catalog: Catalog? {
        didSet {
            cells = catalog?.sliderIds.map {ProductCell(id: $0)} ?? []
        }
    }
    
    
    func connectTo(view: SliderViewCell) {
        view.productsView.dataSource = self
        view.productsView.register(
            UINib(nibName: cellsNames[1], bundle: nil),
            forCellWithReuseIdentifier: reuseIdentifiers[1]
        )
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifiers[1],
            for: indexPath
            ) as! ProductCollectionViewCell
        
        return cells[indexPath.row].setView(view: cellView, catalog: catalog)
    }
}

extension SliderController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: ProductCollectionViewCell.height)
    }
}

class ProductsCollectionViewController: UICollectionViewController {
    
    private let slider = SliderController()
    
    private var catalog: Catalog? {
        didSet {
            cells = catalog?.productsIds.map {ProductCell(id: $0)} ?? []
            slider.catalog = catalog
            
            collectionView.reloadData()
        }
    }
    
    private var cells: [ProductCell] = []
    
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
    
    
    private func registerCells() {
        for (name, id) in zip(cellsNames, reuseIdentifiers) {
            collectionView!.register(
                UINib(nibName: name, bundle: nil),
                forCellWithReuseIdentifier: id
            )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCatalog()
        
        registerCells()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return slider.notCells ? 0 : 1
        case 1: return cells.count
        default: return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let view = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifiers[indexPath.section],
            for: indexPath
            )
        if let cellView = view as? ProductCollectionViewCell {
            return cells[indexPath.row].setView(view: cellView, catalog: catalog)
        }
        if let sliderView = view as? SliderViewCell {
            slider.connectTo(view: sliderView)
            return sliderView
        }

        return view
    }
}

extension ProductsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.frame.size.width,
            height: indexPath.section == 1 ? ProductCollectionViewCell.height : SliderViewCell.height
        )
    }
}
