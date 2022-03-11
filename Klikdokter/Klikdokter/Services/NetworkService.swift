//
//  NetworkService.swift
//  Klikdokter
//
//  Created by Huy Lai on 3/10/22.
//

import Alamofire

protocol Endpoint {
    var baseUrl: String { get }
    var path: String { get }
    var fullUrl: String { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var body: Parameters { get }
    var headers: HTTPHeaders { get }
}

extension Endpoint {
    var encoding: ParameterEncoding {
        return method == .get ? URLEncoding.default : JSONEncoding.default
    }
    var fullUrl: String {
        return baseUrl + path
    }
    var body: Parameters {
        return Parameters()
    }
}

typealias ResponseClosure = (DataResponse<Any>?) -> Void
let manager: SessionManager = createSessionManager()

func createSessionManager() -> SessionManager {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
    return SessionManager(configuration: configuration)
}

struct NetworkService {
    init() {
        startNetworkReachabilityObserver()
    }
    static let shared = NetworkService()
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
}

extension NetworkService {
    func request(_ endpoint: Endpoint, completion: @escaping ResponseClosure) -> Request {
        let request = manager.request(
            endpoint.fullUrl,
            method: endpoint.method,
            parameters: endpoint.body,
            encoding: endpoint.encoding,
            headers: endpoint.headers
            ).validate()
            .responseJSON { response in
                if response.result.isSuccess {
                    debugPrint(response.result.description)
                } else {
                    debugPrint(response.result.error ?? "Error")
                }
                // Completion handler
                completion(response)
        }
        return request
    }

    func startNetworkReachabilityObserver() {
        reachabilityManager?.listener = { status in
            switch status {
            case .notReachable:
                print("The network is not reachable")
            case .unknown :
                print("It is unknown whether the network is reachable")
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
            }
        }
        // Start listening
        reachabilityManager?.startListening()
    }

    func hasInternetConnection() -> Bool {
        return reachabilityManager != nil && (reachabilityManager?.isReachable)!
    }
}
