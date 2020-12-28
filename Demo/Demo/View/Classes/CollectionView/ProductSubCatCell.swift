//
//  ProductSubCatCell.swift
//  Demo
//
//  Created by Maitri Dutta Banik on 28/12/20.
//

import UIKit

class ProductSubCatCell: UICollectionViewCell {
    @IBOutlet private var categoryName: UILabel!
    @IBOutlet private var categoryCount: UILabel!
    @IBOutlet private var chevron: UIImageView!
    @IBOutlet private var productCollectionView: UICollectionView!
    @IBOutlet private var productCollectionViewHeight: NSLayoutConstraint!
    
    private var products: [ProductModel.Product]?
    var itemDelegate: ItemCellCartInteractionDelegate?
    var isExpanded = false
    
    func load(_ data: ProductModel.Subcategory?) {
        guard let data = data else { return }
        if isExpanded {
            productCollectionViewHeight.constant = CGFloat(data.products.count * 105)
        } else {
            productCollectionViewHeight.constant = 0
        }
        products = data.products
        categoryName.text = data.subCatName
        categoryCount.text = "\(data.totalItems)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productCollectionView.reloadData()
    }
}

extension ProductSubCatCell: UICollectionViewable {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.delegate = itemDelegate
        cell.load(products?[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 100)
    }
}
