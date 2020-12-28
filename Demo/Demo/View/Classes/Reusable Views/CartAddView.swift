//
//  CartAddView.swift
//  Demo
//
//  Created by Maitri Dutta Banik on 28/12/20.
//

import UIKit

class CartAddView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var itemCount: UILabel!
    @IBOutlet private var totalPrice: UILabel!
    @IBOutlet private var from: UILabel!
    
    static private var nibName = "CartAddView"
    
    var products: [ProductModel.Product] = [] {
        didSet {
            displayInfo()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFromNib()
    }
    
    private func initFromNib() {
        Bundle.main.loadNibNamed(Self.nibName, owner: self)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        transform = CGAffineTransform(translationX: 0, y: 500)
        displayInfo()
        UIView.animate(withDuration: 0.5, delay: 0.2) { [self] in
            transform = .identity
        }
    }
    
    fileprivate func displayInfo() {
        if products.isEmpty {
            removeFromSuperview()
            return
        }
        itemCount.text = "\(products.count)" + (products.count <= 1 ? " item" : " items")
        totalPrice.text = String((products.map { Double($0.price)! }).reduce(0, +))
        setNeedsDisplay()
    }
}
