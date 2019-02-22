//
//  SearchCollectionViewController.swift
//  E Shop
//
//  Created by Daniel Urumov on 18.02.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

private let reuseIdentifiers = ["ProductCollectionViewCell"]

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
        reuseIdentifiers.forEach {
            collectionView.register(
                UINib(nibName: $0, bundle: nil),
                forCellWithReuseIdentifier: $0
            )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar(searchBar, textDidChange: searchBar.text ?? "")
        collectionView.backgroundColor = .white
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifiers[0],
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

private func match(text: String, pattern: String) -> Bool {
    return text.range(of: pattern, options: .caseInsensitive) != nil
}

extension SearchCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //simple ineffective algorithm
        if searchText == "" {
            products = []
        } else {
            var set: Set<Product> = Set()
            set.formUnion(catalog.products.filter { match(text: $0.title, pattern: searchText) })
            set.formUnion(catalog.products.filter {
                let category = catalog.getCategory(id: $0.category)
                if let parentId = category.parentId, match(text: catalog.getCategory(id: parentId).title, pattern: searchText) {
                    return true
                }
                return match(text: category.title, pattern: searchText)
            })
            set.formUnion(catalog.products.filter {match(text: $0.description, pattern: searchText)})
            products = Array(set)
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
