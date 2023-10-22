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
        tableView.register(ProductLandscapeTVCell.nib(), forCellReuseIdentifier: ProductLandscapeTVCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.setContentEmptyTitle("No products in the Cart! 🧐")
        self.setContentEmptyImage(UIImage(named: "empty_2"))
        
//        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
//            guard let self = self else { return }
//            self.isContentEmptyViewHidden = !self.isContentEmptyViewHidden
//        }
        
        
//        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
//            guard let self = self else { return }
//            self.isLoadingIndicatorAnimating = !self.isLoadingIndicatorAnimating
//        }
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
        self.isContentEmptyViewHidden = !products.isEmpty
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductLandscapeTVCell.identifier, for: indexPath) as! ProductLandscapeTVCell
        cell.setProduct(products[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ProductLandscapeTVCell.height
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete")
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}


extension CartViewController: ProductLandscapeCellDelegate {
    func didDeleteProduct(withID id: Int) {
        if let index = products.firstIndex(where: { $0.id == id }) {
            // Remove First
            products.remove(at: index)
            // Then Update TableView
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            // Then Update the Price
            updateTotalPrice()
        }
    }
    
    func didUpdateProductQuantity(forProductID id: Int, with quantity: Int) {
        if let index = products.firstIndex(where: { $0.id == id}) {
            products[index].quantity = quantity
        }
        
        updateTotalPrice()
    }
}
