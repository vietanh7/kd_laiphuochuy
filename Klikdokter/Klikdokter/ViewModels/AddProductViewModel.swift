//
//  AddProductViewModel.swift
//  Klikdokter
//
//  Created by Huy Lai on 3/10/22.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class AddProductViewModel: BaseViewModel {
    func addProduct(_ sku: String, _ productName: String, _ unit: String, _ price: String, _ qty: String) {
        if !isValidAllInputs(sku, productName, unit, price, qty) {
            return
        }
        let parameters: Parameters = ["sku": sku, "product_name": productName, "unit": unit, "qty": Int(qty) ?? 0, "price": Int(price) ?? 0, "status": "1"]
        isLoading.accept(true)
        _ = NetworkService().request(ProductRequest.addProduct(parameters), completion: { [weak self] response in
                guard let self = self else { return }
                self.isLoading.accept(false)
                guard let statusCode = response?.response?.statusCode else { return }
                let errorMessage = Constants.Messages.cannotAdd
                switch statusCode {
                case 200:
                    do {
                        let _ = try JSONDecoder().decode(Product.self, from: (response?.data)!)
                        self.successMessage.accept(Constants.Messages.addedProductSuccessfully)
                        self.isSuccess.accept(true)
                    } catch {
                        do {
                            let errorResponse = try JSONDecoder().decode(ProductErrorResponse.self, from: (response?.data)!)
                            self.errorMessage.accept(errorResponse.message)
                        } catch {
                            self.errorMessage.accept(errorMessage)
                        }
                        self.isSuccess.accept(false)
                    }
                case 400:
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self , from: (response?.data)!)
                        if errorResponse.error.contains("token") {
                            self.resetAccessToken()
                        }
                        self.errorMessage.accept(errorResponse.error)
                        self.isSuccess.accept(false)
                    } catch {
                        self.errorMessage.accept(errorMessage)
                        self.isSuccess.accept(false)
                    }
                default:
                    self.errorMessage.accept(errorMessage)
                    self.isSuccess.accept(false)
                }
        })
    }

    func editProduct(_ sku: String, _ productName: String, _ unit: String, _ price: String, _ qty: String) {
        if !isValidAllInputs(sku, productName, unit, price, qty) {
            return
        }
        let parameters: Parameters = ["sku": sku, "product_name": productName, "unit": unit, "qty": Int(qty) ?? 0, "price": Int(price) ?? 0, "status": "1"]
        isLoading.accept(true)
        _ = NetworkService().request(ProductRequest.editProduct(parameters), completion: { [weak self] response in
                guard let self = self else { return }
                self.isLoading.accept(false)
                guard let statusCode = response?.response?.statusCode else { return }
                let errorMessage = Constants.Messages.cannotEdit
                switch statusCode {
                case 200:
                    do {
                        let _ = try JSONDecoder().decode(Product.self, from: (response?.data)!)
                        self.successMessage.accept(Constants.Messages.editedProductSuccessfully)
                        self.isSuccess.accept(true)
                    } catch {
                        do {
                            let errorResponse = try JSONDecoder().decode(ProductErrorResponse.self, from: (response?.data)!)
                            self.errorMessage.accept(errorResponse.message)
                        } catch {
                            self.errorMessage.accept(errorMessage)
                        }
                        self.isSuccess.accept(false)
                    }
                case 400:
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self , from: (response?.data)!)
                        if errorResponse.error.contains("token") {
                            self.resetAccessToken()
                        }
                        self.errorMessage.accept(errorResponse.error)
                        self.isSuccess.accept(false)
                    } catch {
                        self.errorMessage.accept(errorMessage)
                        self.isSuccess.accept(false)
                    }
                default:
                    self.errorMessage.accept(errorMessage)
                    self.isSuccess.accept(false)
                }
        })
    }

    private func isValidAllInputs(_ sku: String, _ productName: String, _ unit: String, _ price: String, _ qty: String) -> Bool {
        if !NetworkService.shared.hasInternetConnection() {
            errorMessage.accept(Constants.Messages.noInternetConnection)
            return false
        }
        if sku.isEmpty {
            errorMessage.accept(Constants.Messages.skuIsInvalid)
            return false
        }
        if productName.isEmpty {
            errorMessage.accept(Constants.Messages.productNameIsInvalid)
            return false
        }
        if unit.isEmpty {
            errorMessage.accept(Constants.Messages.unitIsInvalid)
            return false
        }
        if price.isEmpty, let _ = Int(price) {
            errorMessage.accept(Constants.Messages.priceIsInvalid)
            return false
        }
        if qty.isEmpty, let _ = Int(qty) {
            errorMessage.accept(Constants.Messages.quanlityIsInvalid)
            return false
        }
        return true
    }
}
