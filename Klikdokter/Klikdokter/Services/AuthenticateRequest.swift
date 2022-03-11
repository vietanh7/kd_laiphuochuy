//
//  AuthenticateRequest.swift
//  Klikdokter
//
//  Created by Huy Lai on 3/10/22.
//

import Foundation
import Alamofire

enum AuthenticateRequest {
    case register(_ parameters: Parameters)
    case logIn(_ parameters: Parameters)
}

extension AuthenticateRequest: Endpoint {
    var baseUrl: String {
        return Constants.Endpoint.baseUrl
    }

    var path: String {
        switch self {
        case .register: return "register"
        case .logIn: return "auth/login"
        }
    }

    var method: HTTPMethod {
        return .post
    }

    var headers: HTTPHeaders {
        return [:]
    }

    var body: Parameters {
        var body: Parameters = Parameters()
        switch self {
        case .register(let parameters):
            body = parameters
        case .logIn(let parameters):
            body = parameters
        }
        debugPrint("\(body)")
        return body
    }
}
