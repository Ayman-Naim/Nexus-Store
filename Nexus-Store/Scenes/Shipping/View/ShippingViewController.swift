//
//  ShippingViewController.swift
//  Nexus-Store
//
//  Created by Khater on 18/10/2023.
//

import UIKit

class ShippingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = ShippingViewModel(customerID: K.customerID)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        bindViewModel()
        viewModel.getCustomerAddresses()
    }
    
    private func setupNavigationBar() {
        title = "Shipping Address"
        
        let addAddressBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addAddress))
        addAddressBarButton.tintColor = UIColor(named: "Title")
        navigationItem.rightBarButtonItem = addAddressBarButton
    }
    
    private func setupTableView() {
        tableView.register(AddressTableViewCell.nib(), forCellReuseIdentifier: AddressTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func addAddress() {
        let addAddressVC = AddAddressViewController()
        addAddressVC.delegate = self
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
    
    @IBAction func continueToPaymentButtonPressed(_ sender: UIButton) {
        viewModel.setAddressForOrder {
            self.navigationController?.pushViewController(PayMethodViewController(), animated: true)
        }
    }
    
    
    @IBAction func addPromoCodeButtonPressed(_ sender: UIButton) {
        viewModel.setAddressForOrder {
            self.navigationController?.pushViewController(AddPromoCodeViewController(), animated: true)
        }
    }
    
    
    
    private func bindViewModel() {
        viewModel.reload = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.loadingIndicator = { [weak self] isLoading in
            self?.isLoadingIndicatorAnimating = isLoading
            self?.tableView.isUserInteractionEnabled = !isLoading
        }
        
        viewModel.errorOccure = { [weak self] error in
            guard let self = self else { return }
            Alert.show(on: self, title: "Error", message: error)
        }
    }
}


// MARK: - UITableView DataSource & Delegate
extension ShippingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.identifier, for: indexPath) as! AddressTableViewCell
        viewModel.config(cell: cell, at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCell(at: indexPath.row)
    }
}



// MARK: - AddAddressDelegate
extension ShippingViewController: AddAddressDelegate {
    func didAddNewAddress() {
        viewModel.getCustomerAddresses()
    }
}
