//
//  BaseViewModel.swift
//  Klikdokter
//
//  Created by Huy Lai on 3/10/22.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel: NSObject {
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = BehaviorRelay<String?>(value: nil)
    let successMessage = BehaviorRelay<String?>(value: nil)
    let isSuccess = BehaviorRelay<Bool>(value: false)

    func resetAccessToken() {
        accessToken.accept("")
    }

    func updateAccessToken(_ token: String) {
        accessToken.accept(token)
    }
}
