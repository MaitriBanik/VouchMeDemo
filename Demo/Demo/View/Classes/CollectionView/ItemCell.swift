//
//  ItemCell.swift
//  Demo
//
//  Created by Maitri Dutta Banik on 28/12/20.
//

import UIKit

protocol ItemCellCartInteractionDelegate: class {
    func didAdd(_ item: ProductModel.Product)
    func changeItem(_ count: String, forItem item: ProductModel.Product, type: ItemCell.ItemChangeType)
}

class ItemCell: UICollectionViewCell {
    @IBOutlet private var itemImage: UIImageView!
    @IBOutlet private var itemName: UILabel!
    @IBOutlet private var itemPrice: UILabel!
    @IBOutlet private var itemSellingPrice: UILabel!
    @IBOutlet private var itemDescription: UILabel!
    @IBOutlet private var addButton: UIButton!
    @IBOutlet private var counterStack: UIStackView!
    @IBOutlet private var itemCountLabel: UILabel!
    @IBOutlet private var increaseButton: UIButton!
    @IBOutlet private var decreaseButton: UIButton!
    
    weak var delegate: ItemCellCartInteractionDelegate?
    private var item: ProductModel.Product!
    private var itemCount: Int = 0 {
        willSet {
            itemCountLabel.text = "\(newValue)"
            if newValue > 0 {
                showStepper()
            } else {
                hideStepper()
            }
        }
    }
    
    func load(_ data: ProductModel.Product?) {
        guard let data = data else { return }
        item = data
        itemImage.sd_setImage(with: URL(string: data.image))
        itemName.text = data.name
        itemSellingPrice.text = data.salePrice
        itemDescription.text = data.shortDescription
        
        let attr = NSAttributedString(string: data.price, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        itemPrice.attributedText = attr
    }
    
    @IBAction private
    func addItemToCart(_ sender: UIButton) {
        Haptic.playHaptic(type: .intense, duration: .short)
        itemCount = 1
        delegate?.didAdd(item)
    }
    
    @IBAction private
    func increaseItemCount(_ sender: UIButton) {
        Haptic.playHaptic(type: .intense, duration: .short)
        itemCount += 1
        delegate?.changeItem(itemCountLabel.text ?? "0", forItem: item, type: .increase)
    }
    
    @IBAction private
    func decreaseItemCount(_ sender: UIButton) {
        Haptic.playHaptic(type: .intense, duration: .short)
        itemCount -= 1
        delegate?.changeItem(itemCountLabel.text ?? "0", forItem: item, type: .decrease)
    }
    
    fileprivate func showStepper() {
        counterStack.isHidden = false
        UIView.animate(withDuration: 0.2, animations: { [self] in
            addButton.alpha = 0
            counterStack.alpha = 1
        }) { [self] _ in
            addButton.isHidden = true
        }
    }
    
    fileprivate func hideStepper() {
        addButton.isHidden = false
        UIView.animate(withDuration: 0.2, animations: { [self] in
            addButton.alpha = 1
            counterStack.alpha = 0
        }) { [self] _ in
            counterStack.isHidden = true
        }
    }
    
    enum ItemChangeType {
        case increase
        case decrease
    }
}
