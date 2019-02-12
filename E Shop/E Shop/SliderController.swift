//
//  SliderController.swift
//  E Shop
//
//  Created by Daniel Urumov on 12.02.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import Foundation
import UIKit

class SliderController: NSObject, UICollectionViewDataSource {
    
    var cells: [ProductCell] = [] {
        didSet {
            updatePageControlSize()
        }
    }
    
    private weak var view: SliderViewCell! {
        didSet {
            view.productsView.dataSource = self
            view.productsView.delegate = self
            view.productsView.register(
                UINib(nibName: cellsNames[1], bundle: nil),
                forCellWithReuseIdentifier: reuseIdentifiers[1]
            )
            
            updatePageControlSize()
        }
    }
    
    private func updatePageControlSize() {
        view?.pageControl.numberOfPages = cells.count
    }
    
    var notCells: Bool {
        get {
            return cells.isEmpty
        }
    }
    
    func connectTo(view: SliderViewCell) {
        self.view = view
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
        
        cells[indexPath.row].setView(view: cellView)
        return cellView
    }
}

extension SliderController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: ProductCollectionViewCell.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        view.pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if view.pageControl.currentPage < indexPath.item {
            view.pageControl.currentPage += 1
        } else if view.pageControl.currentPage > indexPath.item {
            view.pageControl.currentPage -= 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
    }
}
