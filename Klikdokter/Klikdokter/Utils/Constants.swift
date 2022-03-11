//
//  Constants.swift
//  Klikdokter
//
//  Created by Huy Lai on 3/10/22.
//

import Foundation

struct Constants {
    struct Endpoint {
        static let baseUrl = "https://hoodwink.medkomtek.net/api/"
    }

    struct Messages {
        static let noInternetConnection = "No internet connection"
        static let unexpectedError = "Unexpected error"
        static let emailIsInvalid = "Email address is invalid"
        static let passwordIsInvalid = "Password is invalid"
        static let skuIsInvalid = "Sku is invalid"
        static let productNameIsInvalid = "Product name is invalid"
        static let quanlityIsInvalid = "Quanlity is invalid"
        static let unitIsInvalid = "Unit is invalid"
        static let priceIsInvalid = "Price is invalid"
        static let cannotAdd = "Cannot add this product"
        static let addedProductSuccessfully = "Added product successfully"
        static let cannotEdit = "Cannot edit this product"
        static let editedProductSuccessfully = "Edited product successfully"
        static let cannotGet = "Cannot get product list"
        static let cannotDelete = "Cannot delete product list"
        static let deletedProductSuccessfully = "Deleted product successfully"
    }
}
