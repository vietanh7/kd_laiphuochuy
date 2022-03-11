//
//  AuthenticateViewModel.swift
//  Klikdokter
//
//  Created by Huy Lai on 3/10/22.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class AuthenticateViewModel: BaseViewModel {
    func register(_ email: String, _ password: String) {
        if !isValidAllInputs(email, password) {
            return
        }
        let parameters = ["email" : email, "password": password]
        isLoading.accept(true)
        _ = NetworkService().request(AuthenticateRequest.register(parameters), completion: { [weak self] response in
            guard let self = self else { return }
            self.isLoading.accept(false)
            guard let statusCode = response?.response?.statusCode else {
                self.isSuccess.accept(false)
                return
            }
            switch statusCode {
            case 200:
                do {
                    let registerResponse = try JSONDecoder().decode(RegisterResponse.self , from: (response?.data)!)
                    if registerResponse.success {
                        self.successMessage.accept(registerResponse.message)
                        self.logIn(email, password)
                    } else {
                        self.errorMessage.accept(registerResponse.message)
                        self.isSuccess.accept(false)
                    }
                } catch {
                    self.isSuccess.accept(false)
                }
            case 400:
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self , from: (response?.data)!)
                    self.errorMessage.accept(errorResponse.error)
                    self.isSuccess.accept(false)
                } catch {
                    self.isSuccess.accept(false)
                }
            default:
                self.errorMessage.accept(Constants.Messages.unexpectedError)
                self.isSuccess.accept(false)
            }
        })
    }

    func logIn(_ email: String, _ password: String) {
        if !isValidAllInputs(email, password) {
            return
        }
        let parameters = ["email" : email, "password": password]
        isLoading.accept(true)
        _ = NetworkService().request(AuthenticateRequest.logIn(parameters), completion: { [weak self] response in
            guard let self = self else { return }
            self.isLoading.accept(false)
            guard let statusCode = response?.response?.statusCode else {
                self.isSuccess.accept(false)
                return
            }
            switch statusCode {
            case 200:
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self , from: (response?.data)!)
                    self.updateAccessToken(loginResponse.token)
                    self.isSuccess.accept(true)
                } catch {
                    self.isSuccess.accept(false)
                }
            case 400:
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self , from: (response?.data)!)
                    self.errorMessage.accept(errorResponse.error)
                    self.isSuccess.accept(false)
                } catch {
                    self.isSuccess.accept(false)
                }
            default:
                self.errorMessage.accept(Constants.Messages.unexpectedError)
                self.isSuccess.accept(false)
            }
        })
    }

    private func isValidAllInputs(_ email: String, _ password: String) -> Bool {
        if !NetworkService.shared.hasInternetConnection() {
            errorMessage.accept(Constants.Messages.noInternetConnection)
            return false
        }
        if !email.isValidEmail {
            errorMessage.accept(Constants.Messages.emailIsInvalid)
            return false
        }
        if !password.isValidPassword {
            errorMessage.accept(Constants.Messages.passwordIsInvalid)
            return false
        }
        return true
    }
}
