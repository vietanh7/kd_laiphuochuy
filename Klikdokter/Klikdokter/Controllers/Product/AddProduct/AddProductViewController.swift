//
//  AddProductViewController.swift
//  Klikdokter
//
//  Created by Huy Lai on 3/10/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class AddProductViewController: UIViewController {
    @IBOutlet weak var skuTextField: UITextField!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    
    var selectedProduct: Product?
    let addProductViewModel = AddProductViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        addObservers()
        updateData()
    }

    private func addObservers() {
        addProductViewModel.isLoading.distinctUntilChanged().subscribe(onNext: { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.showLoading()
                } else {
                    self?.dismissLoading()
                }
            }
        }).disposed(by: disposeBag)
        addProductViewModel.isSuccess.subscribe(onNext: { [weak self] isSuccess in
            if isSuccess {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }).disposed(by: disposeBag)
        addProductViewModel.errorMessage.subscribe(onNext: { [weak self] errorMessage in
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                DispatchQueue.main.async {
                    self?.createBanner(errorMessage, .danger)
                    if errorMessage.contains("token") {
                        self?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }).disposed(by: disposeBag)
        addProductViewModel.successMessage.subscribe(onNext: { [weak self] successMessage in
            if let successMessage = successMessage, !successMessage.isEmpty {
                DispatchQueue.main.async {
                    self?.createBanner(successMessage, .success)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func updateData() {
        if let selectedProduct = selectedProduct {
            actionButton.setTitle("Edit", for: .normal)
            skuTextField.isUserInteractionEnabled = false
            skuTextField.alpha = 0.3
            skuTextField.text = selectedProduct.sku
            productNameTextField.text = selectedProduct.productName
            qtyTextField.text = String(selectedProduct.qty)
            priceTextField.text = String(selectedProduct.price)
            unitTextField.text = selectedProduct.unit
        } else {
            actionButton.setTitle("Add", for: .normal)
        }
    }

    @IBAction func clickOnActionButton(_ sender: UIButton) {
        let sku = skuTextField.text ?? ""
        let productName = productNameTextField.text ?? ""
        let qty = qtyTextField.text ?? ""
        let price = priceTextField.text ?? ""
        let unit = unitTextField.text ?? ""
        if selectedProduct == nil {
            addProductViewModel.addProduct(sku, productName, unit, price, qty)
        } else {
            addProductViewModel.editProduct(sku, productName, unit, price, qty)
        }
    }

    @IBAction func clickOnCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
