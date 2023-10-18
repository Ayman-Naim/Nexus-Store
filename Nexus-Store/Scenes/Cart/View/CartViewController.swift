//
//  CartViewController.swift
//  Nexus-Store
//
//  Created by Khater on 18/10/2023.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Cart"
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupTableView() {
        tableView.register(CartProductTableViewCell.nib(), forCellReuseIdentifier: CartProductTableViewCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    @IBAction func checkoutButtonPressed(_ sender: UIButton) {
        print("checkoutButtonPressed")
    }
    
}



// MARK: - UITableView DataSource
extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartProductTableViewCell.identifier, for: indexPath) as! CartProductTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height * 0.25
    }
}
