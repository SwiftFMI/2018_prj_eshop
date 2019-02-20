//
//  SliderController.swift
//  E Shop
//
//  Created by Daniel Urumov on 12.02.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifiers = ["ProductCollectionViewCell"]

class Slider: NSObject, UICollectionViewDataSource {
    
    var delegate: ProductsViewControllerDelegate?
    
    var products: [Product] = [] {
        didSet {
            updatePageControlSize()
        }
    }
    
    weak var view: SliderViewCell! {
        didSet {
            if oldValue?.hashValue != view.hashValue {
                view.productsView.dataSource = self
                view.productsView.delegate = self
                reuseIdentifiers.forEach {
                    view.productsView.register(
                        UINib(nibName: $0, bundle: nil),
                        forCellWithReuseIdentifier: $0
                    )
                }
                updatePageControlSize()
            }
        }
    }
    
    private func updatePageControlSize() {
        view?.pageControl.numberOfPages = products.count
    }
    
    var isHidden: Bool {
        get {
            return products.isEmpty
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifiers[0],
            for: indexPath
            ) as! ProductCollectionViewCell
        initView(product: products[indexPath.row], view: cellView)
        return cellView
    }
}

extension Slider: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: ProductCollectionViewCell.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        view.pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.size.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let pageControl = view.pageControl!
        
        if pageControl.currentPage < indexPath.row {
            pageControl.currentPage += 1
        } else if pageControl.currentPage > indexPath.row {
            pageControl.currentPage -= 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectItem(products: products, index: indexPath.row)
    }
}
