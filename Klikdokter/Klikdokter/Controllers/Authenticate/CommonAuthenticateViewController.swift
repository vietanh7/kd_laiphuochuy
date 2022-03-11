//
//  CommonAuthenticateViewController.swift
//  Klikdokter
//
//  Created by Huy Lai on 3/10/22.
//

import UIKit
import RxSwift
import RxCocoa

class CommonAuthenticateViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var actionButton: UIButton!

    let authenticateModel = AuthenticateViewModel()
    let disposeBag = DisposeBag()
    var isLogInMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        actionButton.setTitle(isLogInMode ? "Login" : "Register", for: .normal)
        addObservers()
    }

    private func addObservers() {
        authenticateModel.isLoading.distinctUntilChanged().subscribe(onNext: { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.showLoading()
                } else {
                    self?.dismissLoading()
                }
            }
        }).disposed(by: disposeBag)
        authenticateModel.isSuccess.subscribe(onNext: { [weak self] isSuccess in
            if isSuccess {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }).disposed(by: disposeBag)
        authenticateModel.errorMessage.subscribe(onNext: { [weak self] errorMessage in
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                DispatchQueue.main.async {
                    self?.createBanner(errorMessage, .danger)
                }
            }
        }).disposed(by: disposeBag)
        authenticateModel.successMessage.subscribe(onNext: { [weak self] successMessage in
            if let successMessage = successMessage, !successMessage.isEmpty {
                DispatchQueue.main.async {
                    self?.createBanner(successMessage, .success)
                }
            }
        }).disposed(by: disposeBag)
    }

    @IBAction func clickOnActionButton(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        if isLogInMode {
            authenticateModel.logIn(email, password)
        } else {
            authenticateModel.register(email, password)
        }
    }

    @IBAction func clickOnCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

