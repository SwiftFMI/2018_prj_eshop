//
//  SearchCollectionViewController.swift
//  E Shop
//
//  Created by Daniel Urumov on 18.02.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

class SearchCollectionViewController: UICollectionViewController {
    @IBOutlet var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.text = ""
            searchBar.showsCancelButton = true
            searchBar.isHidden = false
            //searchBar.backgroundColor = green
            searchBar.placeholder = "Search Product".localizedCapitalized
            cancelSearchButton = (searchBar.value(forKey: "cancelButton") as! UIButton)
            navigationItem.titleView = searchBar
        }
    }
    
    private weak var cancelSearchButton: UIButton! {
        didSet {
            cancelSearchButton.isEnabled = true
            cancelSearchButton.tintColor = .white
        }
    }
    
    var delegate: ProductsViewControllerDelegate?
    
    var catalog: Catalog!
    
    private var products: [Product] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        collectionView.register(
            UINib(nibName: cellsNames[1], bundle: nil),
            forCellWithReuseIdentifier: reuseIdentifiers[1]
        )
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifiers[1],
            for: indexPath
            ) as! ProductCollectionViewCell
        initView(product: products[indexPath.row], view: cellView)
        return cellView
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectItem(products: products, index: indexPath.row)
    }
}

extension SearchCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.frame.size.width,
            height: ProductCollectionViewCell.height
        )
    }
}

extension SearchCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //simple ineffective algorithm
        
        products = searchText == "" ?
            [] :
            catalog.products.filter {
                $0.title.range(of: searchText, options: .caseInsensitive) != nil
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController!.popViewController(animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        cancelSearchButton.isEnabled = true
    }
}
