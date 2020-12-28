//
//  ProductsViewController.swift
//  Demo
//
//  Created by Maitri Dutta Banik on 28/12/20.
//

import UIKit

class ProductsViewController: MasterViewController {
    @IBOutlet private var loaderView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var productCollectionView: UICollectionView!
    
    private var productModel: ProductModel?
    private var productsQueue = DispatchQueue(label: "app.demo.products.get", qos: .background)
    private var addedProducts: [ProductModel.Product] = []
    
    private var sceneTitle = "Products"
    
    private var expanded: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = ""
        productsQueue.async { [self] in
            getProducts()
        }
    }
}

// MARK: UICollectionView methods
extension ProductsViewController: UICollectionViewable {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        productModel?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productModel?.data[section].subcategories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = productModel?.data[indexPath.section].subcategories[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductSubCatCell", for: indexPath) as! ProductSubCatCell
        cell.itemDelegate = self
        cell.isExpanded = expanded.contains(indexPath)
        cell.load(data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ProductSubCatCell {
            if cell.isExpanded {
                expanded.removeAll { ip -> Bool in
                    return ip == indexPath
                }
            } else {
                expanded.append(indexPath)
            }
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let name = productModel?.data[indexPath.item].catName ?? ""
        let count = productModel?.data[indexPath.item].totalItems ?? 0
        let rv = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProductHeader", for: indexPath) as! ProductHeader
        rv.load(name: name, count: count)
        return rv
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let products = productModel?.data[indexPath.section].subcategories[indexPath.item].products
        if expanded.contains(indexPath) {
            return CGSize(width: collectionView.frame.width, height: CGFloat((products!.count * 105) + 76))
        } else {
            return CGSize(width: collectionView.frame.width, height: 60)
        }
    }
}

// MARK: UI
// THIS EXTENSION IS TO BE USED FOR UI RELATED WORKS
//  SO NOT TO LOSE THE UI SECTION
private extension ProductsViewController {
    func updateViews() {
        UIView.animate(withDuration: 0.57, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseOut]) { [self] in
            loaderView.alpha = 0
        }
        mainQueue.asyncAfter(deadline: .now() + 0.35) { [self] in
            for char in sceneTitle {
                titleLabel.text! += String(char)
                RunLoop.current.run(until: Date() + 0.008)
            }
        }

        productCollectionView.reloadData()
    }
}

// MARK: API
// THIS EXTENSION IS TO BE USED FOR API RELATED WORKS
//  SO NOT TO LOSE THE API SECTION

private extension ProductsViewController {
    func getProducts() {
        APImanager.getProducts { [self] res in
            switch res {
            case let .success(products):
                productModel = products as? ProductModel
                mainQueue.async {
                    updateViews()
                }
            case let .failure(error):
                show(error)
            }
        }
    }
}

// MARK: ItemCellCartInteractionDelegate
extension ProductsViewController: ItemCellCartInteractionDelegate {
    func didAdd(_ item: ProductModel.Product) {
        var shouldReturn = false
        view.subviews.forEach {
            if $0 is CartAddView {
                self.changeItem("1", forItem: item, type: .increase)
                shouldReturn = true
            }
        }
        if shouldReturn { return }
        addedProducts = [item]
        cartAddView = CartAddView(frame: CGRect(x: 16, y: UIScreen.main.bounds.height - (80 + safeAreaInsets.bottom), width: UIScreen.main.bounds.width - 32, height: 80))
        cartAddView.products = addedProducts
        view.addSubview(cartAddView)
    }
    
    func changeItem(_ count: String, forItem item: ProductModel.Product, type: ItemCell.ItemChangeType) {
        if addedProducts.isEmpty {
            addedProducts.removeAll()
        }
        else {
            if type == .increase {
                addedProducts.append(item)
            } else {
                if let index = addedProducts.firstIndex(where: { $0.id == item.id }) {
                    addedProducts.remove(at: index)
                }
            }
        }
        cartAddView.products = addedProducts
    }
}
