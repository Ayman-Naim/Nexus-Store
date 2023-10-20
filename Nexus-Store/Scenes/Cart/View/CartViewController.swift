//
//  CartViewController.swift
//  Nexus-Store
//
//  Created by Khater on 18/10/2023.
//

import UIKit

struct CartProduct {
    let id: Int
    let title: String
    let price: Double
    let image: String
    var quantity: Int
}

class CartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!
    
    private var defaultNavPreferedDisplayTitle = false
    
    var products: [CartProduct] = [
        .init(id: 1, title: "Longline Padded Jacket", price: 10.99, image: "", quantity: 1),
        .init(id: 2, title: "Test", price: 30.59, image: "", quantity: 1),
        .init(id: 3, title: "Test", price: 5.99, image: "", quantity: 1),
        .init(id: 4, title: "Test", price: 12.99, image: "", quantity: 1),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Cart"
        setupTableView()
        updateTotalPrice()
    }
    
    private func setupTableView() {
        tableView.register(CartProductTableViewCell.nib(), forCellReuseIdentifier: CartProductTableViewCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    @IBAction func checkoutButtonPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(ShippingViewController(), animated: true)
    }
    
    private func updateTotalPrice() {
        let totalPrice = products.map { $0.price * Double($0.quantity) }.reduce(0, +)
        totalPriceLabel.text = "$" + String(format: "%.2f", totalPrice)
    }
    
}



// MARK: - UITableView DataSource
extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyView.isHidden = !products.isEmpty
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartProductTableViewCell.identifier, for: indexPath) as! CartProductTableViewCell
        cell.addProduct(products[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CartProductTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete")
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}


extension CartViewController: CartProductCellDelegate {
    func deleteProduct(withID id: Int) {
        products.removeAll(where: { $0.id == id})
        tableView.reloadData()
    }
    
    func didUpdateQuantity(forProductID id: Int, with quantity: Int) {
        if let index = products.firstIndex(where: { $0.id == id}) {
            products[index].quantity = quantity
        }
        
        updateTotalPrice()
    }
}
