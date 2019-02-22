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
    
    @IBOutlet weak var qtyView: UILabel!
    
    private var countsViewArr: [UIView] {
        get {
            return [qtyView, plusButton, minusButton]
        }
    }
    
    var isHiddenCountsView: Bool {
        get {
            return countsViewArr.map {$0.isHidden} .reduce(true) {$0 && $1}
        }
        set {
            countsViewArr.forEach {
                $0.isHidden = newValue
            }
        }
    }
    
    var pan: UIPanGestureRecognizer! {
        didSet {
            pan.delegate = self
            addGestureRecognizer(pan)
        }
    }
    
    static private let deleteButtonAspectCoef = CGFloat(0.2)
    
    var deleteButton: UIButton! {
        didSet {
            deleteButton.isEnabled = false
            deleteButton.backgroundColor = .clear
            deleteButton.setTitle(" delete", for: .normal)
            let titleLabel = deleteButton.titleLabel!
            titleLabel.textAlignment = .left
            titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 20)
            titleLabel.lineBreakMode = .byClipping
            titleLabel.textColor = .white
            deleteButton.addAction(for: .touchUpInside) { [weak self] in
                self?.removeFromCollectionView()
            }
            insertSubview(deleteButton, belowSubview: contentView)
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
        deleteButton = UIButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let point = pan.translation(in: self)
        let width = contentView.frame.width
        let height = contentView.frame.height
        let offset = CartViewProductCell.deleteButtonAspectCoef * width
        
        if pan.state == .changed {
            let x = self.contentView.frame.minX
            self.contentView.frame = CGRect(
                x: min(point.x + x, 0),
                y: 0,
                width: width,
                height: height
            )
            self.deleteButton.frame = CGRect(
                x: self.contentView.frame.maxX,
                y: 0,
                width: min(offset, width - self.contentView.frame.maxX),
                height: height
            )
        } else if deleteButton.isEnabled {
            contentView.frame = CGRect(
                x: -offset,
                y: 0,
                width: width,
                height: height
            )
            deleteButton.frame = CGRect(
                x: contentView.frame.maxX,
                y: 0,
                width: offset,
                height: height
            )
        } else {
            contentView.frame = CGRect(
                x: 0,
                y: 0,
                width: width,
                height: height
            )
        }
    }
    
    private func removeFromCollectionView() {
        let collectionView = superview as! UICollectionView
        let indexPath = collectionView.indexPathForItem(at: center)!
        collectionView.delegate?.collectionView!(
            collectionView,
            performAction: #selector(onPan(_:)),
            forItemAt: indexPath,
            withSender: nil
        )
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            if !deleteButton.isEnabled {
                let view = superview as! UICollectionView
                view.reloadData()
                view.setNeedsLayout()
            }
            if !isHiddenCountsView {
                UIView.animate(withDuration: 0.2) {
                    self.isHiddenCountsView = true
                }
            }
        case .changed:
            setNeedsLayout()
        default:
            let x = contentView.frame.maxX
            if pan.velocity(in: self).x < -500 || x <  0.4 * contentView.frame.width  {
                removeFromCollectionView()
                return
            }
            let flag = x < (1.0 - CartViewProductCell.deleteButtonAspectCoef * 0.9) * contentView.frame.width
            deleteButton.isEnabled = flag
            UIView.animate(withDuration: 0.5) {
                self.isHiddenCountsView = flag
                self.setNeedsLayout()
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (abs(pan.velocity(in: pan.view).x) > abs(pan.velocity(in: pan.view).y) && deleteButton.isEnabled) || (-pan.velocity(in: pan.view).x > abs(pan.velocity(in: pan.view).y) && !deleteButton.isEnabled)
    }
}
