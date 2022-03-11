//
//  ProductListViewModel.swift
//  Klikdokter
//
//  Created by Huy Lai on 3/10/22.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class ProductListViewModel: BaseViewModel {
    var querySku = BehaviorRelay<String>(value: "")
    var searchedProductArray = BehaviorRelay<[Product]>(value: [])
    var baseProductArray: [Product] = []
    var selectedProduct = BehaviorRelay<Product?>(value: nil)
    
    func refreshSearchedProductArray() {
        if querySku.value.isEmpty {
            searchedProductArray.accept(baseProductArray)
        } else {
            searchedProductArray.accept(baseProductArray.filter({ product in
                return product.sku.lowercased().contains(querySku.value.lowercased())
            }))
        }
    }
    
    func getProductList() {
        if accessToken.value.isEmpty {
            isSuccess.accept(false)
            return
        }
        _ = NetworkService().request(ProductRequest.getProductList, completion: { [weak self] response in
            guard let self = self else { return }
            guard let statusCode = response?.response?.statusCode else {
                self.isSuccess.accept(false)
                return
            }
            let errorMessage = Constants.Messages.cannotGet
            switch statusCode {
            case 200:
                do {
                    let productArrayResponse = try JSONDecoder().decode([Product].self, from: (response?.data)!)
                    self.baseProductArray = productArrayResponse
                    self.refreshSearchedProductArray()
                    self.isSuccess.accept(true)
                } catch {
                    self.isSuccess.accept(false)
                    self.errorMessage.accept(errorMessage)
                }
            case 400:
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self , from: (response?.data)!)
                    if errorResponse.error.contains("token") {
                        self.resetAccessToken()
                    }
                    self.errorMessage.accept(errorResponse.error)
                } catch {
                    self.errorMessage.accept(errorMessage)
                }
                self.isSuccess.accept(false)
            default:
                self.errorMessage.accept(errorMessage)
                self.isSuccess.accept(false)
            }
        })
    }

    func deleteProduct(_ sku: String) {
        isLoading.accept(true)
        _ = NetworkService().request(ProductRequest.deleteProduct(sku), completion: { [weak self] response in
            guard let self = self else { return }
            self.isLoading.accept(false)
            guard let statusCode = response?.response?.statusCode else { return }
            let errorMessage = Constants.Messages.cannotDelete
            switch statusCode {
            case 200:
                do {
                    let product = try JSONDecoder().decode(Product.self, from: (response?.data)!)
                    for (index, checkProduct) in self.baseProductArray.enumerated() {
                        if checkProduct.id == product.id {
                            self.baseProductArray.remove(at: index)
                            break
                        }
                    }
                    self.refreshSearchedProductArray()
                    self.successMessage.accept(Constants.Messages.deletedProductSuccessfully)
                } catch {
                    do {
                        let errorResponse = try JSONDecoder().decode(ProductErrorResponse.self, from: (response?.data)!)
                        self.errorMessage.accept(errorResponse.message)
                    } catch {
                        self.errorMessage.accept(errorMessage)
                    }
                }
            case 400:
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self , from: (response?.data)!)
                        if errorResponse.error.contains("token") {
                            self.resetAccessToken()
                        }
                        self.errorMessage.accept(errorResponse.error)
                    } catch  {
                        self.errorMessage.accept(errorMessage)
                    }
            default:
                    self.errorMessage.accept(errorMessage)
            }
        })
    }
}
