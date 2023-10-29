//
//  CartViewController.swift
//  Nexus-Store
//
//  Created by Khater on 18/10/2023.
//

import UIKit


class CartViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: CartViewModel = CartViewModel()
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cart"
        setupTableView()
        bindViewModel()
        viewModel.fetchCartProducts()
    }
    
    
    // MARK: - IBActions
    @IBAction func checkoutButtonPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(ShippingViewController(), animated: true)
    }
    
    
    
    // MARK: - Functions
    private func setupTableView() {
        tableView.register(ProductLandscapeTVCell.nib(), forCellReuseIdentifier: ProductLandscapeTVCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.setContentEmptyTitle("No products in the Cart! 🧐")
        self.setContentEmptyImage(UIImage(named: "empty_2"))
    }
    
    private func bindViewModel() {
        viewModel.loadingIndicator = { [weak self] isLoading in
            self?.isLoadingIndicatorAnimating = isLoading
            self?.tableView.isUserInteractionEnabled = !isLoading
        }
        
        viewModel.reload = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.errorOccure = { [weak self] error in
            guard let self = self else { return }
            Alert.show(on: self, title: "Error", message: error)
        }
        
        viewModel.updateTotalPriceLabel = { [weak self] totalPriceText in
            self?.totalPriceLabel.text = totalPriceText
        }
    }
    
}



// MARK: - UITableView DataSource
extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.isContentEmptyViewHidden = viewModel.numberOfRows != 0
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductLandscapeTVCell.identifier, for: indexPath) as! ProductLandscapeTVCell
        viewModel.configCell(cell, at: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ProductLandscapeTVCell.height
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        viewModel.deleteProductFromCart(at: indexPath.row)
    }
}


extension CartViewController: ProductLandscapeCellDelegate {
    func didDeleteProduct(withID id: Int) {
        let closeAction = UIAlertAction(title: "Close", style: .cancel) { _ in
            self.tableView.reloadData()
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteProductFromCart(forCellID: id)
        }
        
        Alert.show(on: self, title: "Cart", message: "Are you sure you want to remove product from cart?", actions: [deleteAction, closeAction])
    }
    
    func didUpdateProductQuantity(forCellID id: Int, with quantity: Int) {
        if quantity <= 0 {
            let closeAction = UIAlertAction(title: "Close", style: .cancel) { _ in
                self.tableView.reloadData()
            }
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                self?.viewModel.deleteProductFromCart(forCellID: id)
            }
            
            Alert.show(on: self, title: "Cart", message: "Are you sure you want to remove product from cart?", actions: [deleteAction, closeAction])
        } else {
            viewModel.didUpdateQuantity(forCellID: id, with: quantity)
        }
    }
}
