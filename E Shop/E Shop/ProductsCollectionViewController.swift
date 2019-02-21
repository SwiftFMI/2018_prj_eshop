//
//  ProductsCollectionViewController.swift
//  E Shop
//
//  Created by Daniel Urumov on 18.01.19.
//  Copyright © 2019 teameshop. All rights reserved.
//

import UIKit

let cart = Cart()

var catalog: Catalog!

let green = UIColor(displayP3Red: 132.0/255.0, green: 191.0/255.0, blue: 37.0/255.0, alpha: 1.0)

private let reuseIdentifiers = ["SliderViewCell", "ProductCollectionViewCell"]

private let catalogUrl = Bundle.main.url(forResource: "catalog", withExtension: "json")!
private let titleImageUrl = Bundle.main.url(forResource: "titleImage", withExtension: "jpg")!

class ProductsCollectionViewController: UICollectionViewController {
    @IBOutlet weak var cartButton: UIButton! {
        didSet {
            cartButton.setTitleColor(green, for: .normal)
            setCartButtonEmptyImage()
        }
    }
    
    private let slider = Slider()
    
    private var sliderHidden = true {
        didSet {
            if oldValue != sliderHidden {
                collectionView.reloadSections(IndexSet(0...0))
            }
        }
    }
    
    private var products: [Product] = [] {
        didSet {
            collectionView.reloadSections(IndexSet(1...1))
        }
    }
    
    private lazy var productViewController = ProductDetailViewController(
        nibName: "ProductDetailViewController",
        bundle: nil
    )
    
    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.hidesWhenStopped = true
        }
    }
    
    private func loadCatalog() {
        navigationController!.navigationBar.isHidden = true
        spinner.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let json = try? Data(contentsOf: catalogUrl) else {
                print("invalid json url")
                return
            }
            catalog = try? JSONDecoder().decode(Catalog.self, from: json)
            guard catalog != nil else {
                print("invalid json format")
                return
            }
            DispatchQueue.main.async {
                self?.navigationController?.navigationBar.isHidden = false
                self?.spinner.stopAnimating()
                self?.slider.products = catalog.sliderProducts
                self?.sliderHidden = self?.slider.isHidden ?? true
                self?.products = catalog.tableProducts
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
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                self?.navigationItem.titleView = imageView
            }
        }
    }
    
    @IBAction func willAppearSearchBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchViewController = storyboard.instantiateViewController(withIdentifier: "SearchCollectionViewController") as! SearchCollectionViewController
        searchViewController.catalog = catalog
        searchViewController.delegate = self
        navigationController!.pushViewController(searchViewController, animated: true)
    }
    
    @IBAction func willAppearCart() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cartViewController = storyboard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        cartViewController.setModel(cart: cart, catalog: catalog)
        navigationController!.pushViewController(cartViewController, animated: true)
    }
    
    @IBAction func willAppearHamburgerMenu() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let hamburgerMenuViewController = storyboard.instantiateViewController(withIdentifier: "HamburgerMenuViewController") as! HamburgerMenuViewController
        hamburgerMenuViewController.catalog = catalog
        navigationController!.pushViewController(hamburgerMenuViewController, animated: true)
    }
    
//
//    func initViewController(_ viewController: SearchCollectionViewController) {
//        viewController.catalog = catalog
//        viewController.delegate = self
//    }
    
    private func config(navigationBar: UINavigationBar) {
        navigationBar.tintColor = .white
        navigationBar.barTintColor = green
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reuseIdentifiers.forEach {
            collectionView.register(
                UINib(nibName: $0, bundle: nil),
                forCellWithReuseIdentifier: $0
            )
        }
        
        cart.delegate = self
        slider.delegate = self
        
        loadCatalog()
        loadTitleImage()
        config(navigationBar: navigationController!.navigationBar)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return products.count
        }
        return sliderHidden ? 0 : 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let view = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifiers[indexPath.section],
            for: indexPath
            )
        
        if let cellView = view as? ProductCollectionViewCell {
            initView(product: products[indexPath.row], view: cellView)
        } else if let sliderViewCell = view as? SliderViewCell {
            slider.view = sliderViewCell
        }

        return view
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 1 else {
            return
        }
        selectItem(products: products, index: indexPath.row)
    }
}

extension ProductsCollectionViewController: ProductsViewControllerDelegate {
    func selectItem(products: [Product], index: Int) {
        productViewController.product = products[index]
        productViewController.cart = cart
        productViewController.cartBarButtonItem = navigationItem.rightBarButtonItems![0]
        navigationController!.pushViewController(productViewController, animated: true)
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

extension ProductsCollectionViewController: CartDelegate {
    private func setCartButtonEmptyImage() {
        cartButton.setBackgroundImage(
            UIImage(
                named: "cart_empty",
                in: Bundle.main,
                compatibleWith: cartButton.imageView?.traitCollection
            ),
            for: .normal
        )
        cartButton.setTitle(nil, for: .normal)
        cartButton.isEnabled = false
    }
    
    private func setCartButtonImage() {
        cartButton.setBackgroundImage(
            UIImage(
                named: "cart",
                in: Bundle.main,
                compatibleWith: cartButton.imageView?.traitCollection
            ),
            for: .normal
        )
        cartButton.isEnabled = true
    }
    
    func updateProducts(count: UInt) {
        if count > 0 && cartButton.currentTitle == nil {
            setCartButtonImage()
        } else if count == 0 && cartButton.currentTitle != nil {
            setCartButtonEmptyImage()
        }
        
        if count > 0 {
            cartButton.setTitle("   \(count)", for: .normal)
        }
    }
}
