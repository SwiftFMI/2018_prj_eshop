//
//  CartViewProductCell.swift
//  E Shop
//
//  Created by Daniel Urumov on 19.02.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

class CartViewProductCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var priceView: UILabel! {
        didSet {
            priceView.textColor = green
        }
    }
    
    @IBOutlet weak var countView: UILabel!
    
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var minusButton: UIButton!
    
    var pan: UIPanGestureRecognizer! {
        didSet {
            pan.delegate = self
            addGestureRecognizer(pan)
        }
    }
    
    var deleteLabel: UILabel! {
        didSet {
            deleteLabel.text = "delete"
            deleteLabel.font = UIFont(name: deleteLabel.font.fontName, size: 30)
            deleteLabel.textColor = .white
            insertSubview(deleteLabel, belowSubview: contentView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentView.backgroundColor = .white
        backgroundColor = .red
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        deleteLabel = UILabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (pan.state == .changed) {
            let point = pan.translation(in: self)
            let width = contentView.frame.width
            let height = contentView.frame.height
            contentView.frame = CGRect(
                x: min(point.x, 0.0),
                y: 0,
                width: width,
                height: height
            )
            deleteLabel.frame = CGRect(
                x: point.x + width + deleteLabel.frame.size.width,
                y: 0,
                width: 100,
                height: height
            )
        }
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            return
        case .changed:
            setNeedsLayout()
        default:
            if pan.velocity(in: self).x < -500 {
                let collectionView = superview as! UICollectionView
                let indexPath = collectionView.indexPathForItem(at: center)!
                collectionView.delegate?.collectionView!(
                    collectionView,
                    performAction: #selector(onPan(_:)),
                    forItemAt: indexPath,
                    withSender: nil
                )
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return -pan.velocity(in: pan.view).x > abs(pan.velocity(in: pan.view).y)
    }
}
