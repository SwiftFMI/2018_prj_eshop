//
//  ProductsCollectionViewController.swift
//  E Shop
//
//  Created by Daniel Urumov on 18.01.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

let cellsNames = ["SliderViewCell", "ProductCollectionViewCell"]

let reuseIdentifiers = ["Slider", "Cell"]

private let catalog_url = Bundle.main.url(forResource: "catalog", withExtension: "json")!

class ProductsCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    @IBOutlet var cancelSearchButtonItem: UIBarButtonItem!
    
    private var leftBarButtonItems: [UIBarButtonItem]?
    
    private var rightBarButtonItems: [UIBarButtonItem]?
    
    private let slider = SliderController()
    
    private var sliderHidden = true
    
    private func updateSliderHidden() {
        sliderHidden = slider.cells.isEmpty
    }
    
    private var cells: [ProductCell] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private func filterProducts(keys: [String]) -> [ProductCell] {
        let set = Set(keys)
        return products.filter {set.contains($0.product.id)}
    }
    
    private var products: [ProductCell] = [] {
        didSet {
            cells = filterProducts(keys: catalog.productsIds)
            slider.cells = filterProducts(keys: catalog.sliderIds)
            updateSliderHidden()
        }
    }
    
    private var catalog: Catalog! {
        didSet {
            products = catalog.all_products.map {ProductCell(product: $0)}
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
    
    @IBAction func willAppearSearchBar() {
        searchBar.isHidden = false
        searchBar.text = ""
        
        leftBarButtonItems = navigationItem.leftBarButtonItems
        rightBarButtonItems = navigationItem.rightBarButtonItems
        
        navigationItem.setLeftBarButtonItems(nil, animated: true)
        navigationItem.setRightBarButton(cancelSearchButtonItem, animated: true)
    }
    
    @IBAction func willDisappearSearchBar() {
        searchBar.isHidden = true
        
        navigationItem.setLeftBarButtonItems(leftBarButtonItems, animated: true)
        navigationItem.setRightBarButtonItems(rightBarButtonItems, animated: true)
        
        leftBarButtonItems = nil
        rightBarButtonItems = nil
        
        updateSliderHidden()
        cells = filterProducts(keys: catalog?.productsIds ?? [])
    }
    
    private func registerCells() {
        for (name, id) in zip(cellsNames, reuseIdentifiers) {
            collectionView.register(
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
        if section == 1 {
            return cells.count
        }
        return sliderHidden ? 0 : 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let view = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifiers[indexPath.section],
            for: indexPath
            )
        if let cellView = view as? ProductCollectionViewCell {
            cells[indexPath.row].setView(view: cellView)
        } else if let sliderView = view as? SliderViewCell {
            slider.connectTo(view: sliderView)
        }

        return view
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
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

extension ProductsCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        sliderHidden = true
        //simple ineffective algorithm
        cells = searchText == "" ? [] : products.filter { $0.product.title.range(of: searchText, options: .caseInsensitive) != nil}
    }
}
