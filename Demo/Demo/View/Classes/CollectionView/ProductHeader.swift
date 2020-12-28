//
//  ProductHeader.swift
//  Demo
//
//  Created by Maitri Dutta Banik on 28/12/20.
//

import UIKit

class ProductHeader: UICollectionReusableView {
    @IBOutlet private var categoryName: UILabel!
    @IBOutlet private var categoryCount: UILabel!
    
    func load(name: String, count: Int) {
        categoryName.text = name
        categoryCount.text = "\(count)" + (count > 1 ? " items" : "item")
    }
}
