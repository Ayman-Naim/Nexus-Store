//
//  ShippingViewController.swift
//  Nexus-Store
//
//  Created by Khater on 18/10/2023.
//

import UIKit

class ShippingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
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
    
    @IBAction func continueToPaymentButtonPressed(_ sender: UIButton) {
        
    }
    
    @objc private func addAddress() {
        self.navigationController?.pushViewController(AddAddressViewController(), animated: true)
    }
}


// MARK: - UITableView DataSource & Delegate
extension ShippingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.identifier, for: indexPath) as! AddressTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath) as! AddressCell
        cell.didSelecteAddress(true)
    }
}
