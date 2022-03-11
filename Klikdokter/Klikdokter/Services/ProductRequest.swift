//
//  ProductRequest.swift
//  Klikdokter
//
//  Created by Huy Lai on 3/10/22.
//

import Alamofire
import RxCocoa
import RxSwift

var accessToken = BehaviorRelay<String>(value: "")

enum ProductRequest {
    case getProductList
    case addProduct(_ parameters: Parameters)
    case editProduct(_ parameters: Parameters)
    case deleteProduct(_ sku: String)
}

extension ProductRequest: Endpoint {
    var baseUrl: String {
        return Constants.Endpoint.baseUrl
    }
    
    var path: String {
        switch self {
        case .getProductList:
            return "items"
        case .addProduct:
            return "item/add"
        case .editProduct:
            return "item/update"
        case .deleteProduct:
            return "item/delete"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProductList:
            return .get
        case .addProduct, .editProduct, .deleteProduct:
            return .post
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getProductList:
            return [
                "Content-Type": "application/json"
            ]
        default:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer " + accessToken.value
            ]
        }
    }
    
    var body: Parameters {
        var body: Parameters = Parameters()
        switch self {
        case .getProductList:
            break
        case .addProduct(let parameters):
            body = parameters
        case .editProduct(let parameters):
            body = parameters
        case .deleteProduct(let sku):
            body = [
                "sku": sku
            ]
        }
        debugPrint("\(body)")
        return body
    }
}
