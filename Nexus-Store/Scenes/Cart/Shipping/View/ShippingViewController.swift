//
//  ShippingViewController.swift
//  Nexus-Store
//
//  Created by Khater on 18/10/2023.
//

import UIKit

class ShippingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var addresses: [(name: String, city: String, address: String, isSelected: Bool)] = [
        ("Home 1", "Test 1", "Test", false),
        ("Home 2", "Test 2", "Test", false),
        ("Home 3", "Test 3", "Test", false),
        ("Home 4", "Test 4", "Test", false),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
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
        
    }
    
    
    @IBAction func addPromoCodeButtonPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(AddPromoCodeViewController(), animated: true)
    }
}


// MARK: - UITableView DataSource & Delegate
extension ShippingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.identifier, for: indexPath) as! AddressTableViewCell
        let address = addresses[indexPath.row]
        cell.setAddress(address)
        cell.selecteAddress(address.isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addresses.indices.forEach({ addresses[$0].isSelected = false })
        addresses[indexPath.row].isSelected = true
        tableView.reloadData()
    }
}



// MARK: - AddAddressDelegate
extension ShippingViewController: AddAddressDelegate {
    func didAddNewAddress(_ address: (name: String, city: String, address: String)) {
        addresses.indices.forEach({ addresses[$0].isSelected = false })
        addresses.insert((name: address.name,
                          city: address.city,
                          address: address.address,
                          isSelected: true), at: 0)
        tableView.reloadData()
    }
}
