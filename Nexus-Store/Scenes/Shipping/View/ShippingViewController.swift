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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupNavigationBar() {
        title = "Shipping"
        
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let addressHeader = ShippingTableViewHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 70))
        addressHeader.setTitle("Address")
        return addressHeader
    }
}
