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

private let catalogUrl = Bundle.main.url(forResource: "catalog", withExtension: "json")!
private let titleImageUrl = Bundle.main.url(forResource: "titleImage", withExtension: "jpg")!

class ProductsCollectionViewController: UICollectionViewController {
    private func createSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        (searchBar.value(forKey: "cancelButton") as! UIButton).isEnabled = true
        searchBar.placeholder = "Search Product".localizedCapitalized
        return searchBar
    }
    
    private lazy var navigationSearchItem = { () -> UINavigationItem in
        let navigationSearchItem = UINavigationItem()
        navigationSearchItem.titleView = createSearchBar()
        return navigationSearchItem
    } ()
    
    private let slider = SliderController()
    
    private var sliderHidden = true {
        didSet {
            if oldValue != sliderHidden {
                collectionView.reloadData()
            }
        }
    }
    
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
            slider.cells = filterProducts(keys: catalog.sliderIds)
            updateSliderHidden()
            cells = filterProducts(keys: catalog.productsIds)
        }
    }
    
    private var catalog: Catalog! {
        didSet {
            products = catalog.all_products.map {ProductCell(product: $0)}
        }
    }
    
    private func loadCatalog() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let json = try? Data(contentsOf: catalogUrl) else {
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
    
    private func loadTitleImage() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let data = try? Data(contentsOf: titleImageUrl), let image = UIImage(data: data) else {
                print("invalid title image url")
                return
            }
            DispatchQueue.main.async {
                self?.navigationItem.titleView = UIImageView(image: image)
            }
        }
    }
    
    @IBAction func willAppearSearchBar() {
        navigationController!.navigationBar.setItems([navigationSearchItem], animated: true)
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
        loadTitleImage()
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
        } else if let sliderViewCell = view as? SliderViewCell {
            slider.connectTo(view: sliderViewCell)
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
        cells = searchText == "" ?
            [] :
            products.filter { $0.product.title.range(of: searchText, options: .caseInsensitive) != nil}
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController!.navigationBar.setItems([navigationItem], animated: true)
        searchBar.text = nil
        updateSliderHidden()
        cells = filterProducts(keys: catalog.productsIds)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        (searchBar.value(forKey: "cancelButton") as! UIButton).isEnabled = true
    }
}


