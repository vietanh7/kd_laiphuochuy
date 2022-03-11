//
//  ProductTableViewCell.swift
//  Klikdokter
//
//  Created by Huy Lai on 3/10/22.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    var selectedProduct: Product?
    var productListViewModel: ProductListViewModel?
        
    func updateProduct(_ product: Product) {
        selectedProduct = product
        skuLabel.text = product.sku
        productNameLabel.text = product.productName
        let isLoggedIn = !accessToken.value.isEmpty
        editButton.setEnabled(isLoggedIn)
        deleteButton.setEnabled(isLoggedIn)
    }

    @IBAction func clickOnEditButton(_ sender: UIButton) {
        if let selectedProduct = selectedProduct {
            productListViewModel?.selectedProduct.accept(selectedProduct)
        }
    }
        
    @IBAction func clickOnDeleteButton(_ sender: UIButton) {
        if let selectedProduct = selectedProduct {
            productListViewModel?.deleteProduct(selectedProduct.sku)
        }
    }
}
