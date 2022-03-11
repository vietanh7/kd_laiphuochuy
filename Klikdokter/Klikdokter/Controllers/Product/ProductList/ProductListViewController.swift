//
//  ProductListViewController.swift
//  Klikdokter
//
//  Created by Huy Lai on 3/10/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ProductListViewController: UIViewController {
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var querySkuTextField: UITextField!
    @IBOutlet weak var productListTableView: UITableView!
    @IBOutlet weak var addProductButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    let productListViewModel = ProductListViewModel()
    let disposeBag = DisposeBag()
    let cellId = "ProductTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        addObservers()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        productListViewModel.getProductList()
    }

    private func addObservers() {
        _ = querySkuTextField.rx.text.map{$0 ?? ""}.bind(to: productListViewModel.querySku)
        productListViewModel.querySku.throttle(.microseconds(300), scheduler: MainScheduler.instance).distinctUntilChanged()
            .subscribe(onNext: { [weak self] queryText in
                self?.productListViewModel.refreshSearchedProductArray()
                if !queryText.isEmpty, self?.productListViewModel.searchedProductArray.value.isEmpty ?? false {
                    self?.noResultLabel.attributedText = self?.getAttributeStringWithUpdateSpecificStringColor("No result found for \(queryText)", queryText)
                    self?.noResultLabel.isHidden = false
                } else {
                    self?.noResultLabel.isHidden = true
                }
        }).disposed(by: disposeBag)
        productListViewModel.isSuccess.subscribe(onNext: { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.productListTableView.refreshControl?.endRefreshing()
            }
        }).disposed(by: disposeBag)
        productListViewModel.isLoading.distinctUntilChanged().subscribe(onNext: { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.showLoading()
                } else {
                    self?.dismissLoading()
                }
            }
        }).disposed(by: disposeBag)
        accessToken.distinctUntilChanged().subscribe(onNext: { [weak self] accessToken in
            DispatchQueue.main.async {
                self?.refreshTableViewAndActionButtons(!accessToken.isEmpty)
            }
        }).disposed(by: disposeBag)
        productListViewModel.errorMessage.subscribe(onNext: { [weak self] errorMessage in
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                DispatchQueue.main.async {
                    self?.createBanner(errorMessage, .danger)
                }
            }
        }).disposed(by: disposeBag)
        productListViewModel.successMessage.subscribe(onNext: { [weak self] successMessage in
            if let successMessage = successMessage, !successMessage.isEmpty {
                DispatchQueue.main.async {
                    self?.createBanner(successMessage, .success)
                }
            }
        }).disposed(by: disposeBag)
        productListViewModel.selectedProduct.subscribe(onNext: { [weak self] selectedProduct in
            if let selectedProduct = selectedProduct {
                DispatchQueue.main.async {
                    self?.showAddProductScreen(selectedProduct)
                }
            }
        }).disposed(by: disposeBag)
    }

    private func refreshTableViewAndActionButtons(_ isLoggedIn: Bool) {
        productListTableView.reloadData()
        addProductButton.setEnabled(isLoggedIn)
        logInButton.setEnabled(!isLoggedIn)
        registerButton.setEnabled(!isLoggedIn)
    }

    private func setupTableView() {
        if #available(iOS 15.0, *) {
            productListTableView.sectionHeaderTopPadding = 0
        }
        productListTableView.keyboardDismissMode = .onDrag
        productListTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        productListTableView.refreshControl = UIRefreshControl()
        productListTableView.rx.setDelegate(self).disposed(by: disposeBag)
        productListTableView.refreshControl?.rx.controlEvent(.valueChanged).subscribe(onNext: { [weak self] in
            self?.productListViewModel.getProductList()
        }).disposed(by: disposeBag)
        let searchedProductArrayObservable = productListViewModel.searchedProductArray.asObservable()
        /* Configure to observe view model variables then handle table view render */
        searchedProductArrayObservable.bind(to: productListTableView.rx.items(cellIdentifier: cellId, cellType:ProductTableViewCell.self)) { (row, element, cell) in
            cell.selectionStyle = .none
            cell.productListViewModel = self.productListViewModel
            cell.updateProduct(element)
        }.disposed(by: disposeBag)

    }

    private func showAuthenticateScreen(_ isLogInMode: Bool) {
        if let commonAuthenticateViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommonAuthenticateViewController") as? CommonAuthenticateViewController {
            commonAuthenticateViewController.modalPresentationStyle = .fullScreen
            commonAuthenticateViewController.isLogInMode = isLogInMode
            self.present(commonAuthenticateViewController, animated: true)
        }
    }

    private func showAddProductScreen(_ selectedProduct: Product? = nil) {
        if let addProductViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddProductViewController") as? AddProductViewController {
            addProductViewController.modalPresentationStyle = .fullScreen
            addProductViewController.selectedProduct = selectedProduct
            self.present(addProductViewController, animated: true)
        }
    }

    func getAttributeStringWithUpdateSpecificStringColor(_ mainString: String,_ stringNeedUpdateColor: String)
    -> NSMutableAttributedString {
        let range = (mainString as NSString).range(of: stringNeedUpdateColor)
        let attribute = NSMutableAttributedString.init(string: mainString)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
        return attribute
    }
    
    @IBAction func clickOnLogInButton(_ sender: UIButton) {
        showAuthenticateScreen(true)
    }
    
    @IBAction func clickOnRegisterButton(_ sender: UIButton) {
        showAuthenticateScreen(false)
    }
    
    @IBAction func clickOnAddProductButton(_ sender: UIButton) {
        showAddProductScreen()
    }
}

extension ProductListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let productListHeaderView = UINib(nibName: "ProductListHeaderView", bundle: nil).instantiate(withOwner: self, options: nil).first as! ProductListHeaderView
        productListHeaderView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50)
        return productListHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
