//
//  SliderViewCell.swift
//  E Shop
//
//  Created by Daniel Urumov on 25.01.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

class SliderViewCell: UICollectionViewCell {

    private static let heightPageControl = CGFloat(20)
    
    static let height = ProductCollectionViewCell.height + heightPageControl
    
    @IBOutlet weak var productsView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            pageControl.currentPageIndicatorTintColor = green
            pageControl.pageIndicatorTintColor = .gray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
