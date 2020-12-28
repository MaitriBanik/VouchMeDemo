//
//  ProductModel.swift
//  Demo
//
//  Created by Maitri Dutta Banik on 28/12/20.
//

import Foundation

// MARK: ProductModel
struct ProductModel: Codable {
    var statusCode: Int
    var status, method: String
    var data: [DataClass]
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case status, method, data, message
    }
    
    
    // MARK: Datum
    struct DataClass: Codable {
        var catID: Int
        var catName: String
        var subCatAvailable: Bool
        var totalItems: Int
        var subcategories: [Subcategory]
        
        enum CodingKeys: String, CodingKey {
            case catID = "cat_id"
            case catName = "cat_name"
            case subCatAvailable = "sub_cat_available"
            case totalItems = "total_items"
            case subcategories
        }
    }
    
    // MARK: Subcategory
    struct Subcategory: Codable {
        var subCatID: Int
        var subCatName: String
        var totalItems: Int
        var products: [Product]
        
        enum CodingKeys: String, CodingKey {
            case subCatID = "sub_cat_id"
            case subCatName = "sub_cat_name"
            case totalItems = "total_items"
            case products
        }
    }
    
    // MARK: Product
    struct Product: Codable {
        var id: Int
        var name: String
        var categoryID, subCategoryID, storeID: Int
        var image: String
        var shortDescription, price, salePrice: String
        var type, status, quantity, maxQuantityAllowed: Int
        var isPrescriptionNeeded, isTaxable, outOfStock: Int
        
        enum CodingKeys: String, CodingKey {
            case id, name
            case categoryID = "category_id"
            case subCategoryID = "sub_category_id"
            case storeID = "store_id"
            case image
            case shortDescription = "short_description"
            case price
            case salePrice = "sale_price"
            case type, status, quantity
            case maxQuantityAllowed = "max_quantity_allowed"
            case isPrescriptionNeeded = "is_prescription_needed"
            case isTaxable = "is_taxable"
            case outOfStock = "out_of_stock"
        }
    }
}
