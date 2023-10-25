//
//  WishListViewController.swift
//  Nexus-Store
//
//  Created by Khater on 25/10/2023.
//

import UIKit

class WishListViewController: UIViewController {
    
    private let viewModel: WishListViewModel = WishListViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "Background")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(named: "Background")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Wish List"
        setupTableView()
        bindViewModel()
        viewModel.fetchProducts()
        
        self.setContentEmptyTitle("No products in Wish list")
    }
    
    // MARK: - Helpers
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ProductLandscapeTVCell.nib(), forCellReuseIdentifier: ProductLandscapeTVCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.loadingIndicator = { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.isLoadingIndicatorAnimating = isLoading
            }
        }
        
        viewModel.reload = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.errorOccure = { [weak self] error in
            guard let self = self else { return }
            Alert.show(on: self, title: "Error", message: error)
        }
    }
}


// MARK: - UITableView DataSource & Delegate
extension WishListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.isContentEmptyViewHidden = viewModel.numberOfRow != 0
        return viewModel.numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductLandscapeTVCell.identifier, for: indexPath) as! ProductLandscapeTVCell
        viewModel.configCell(cell, at: indexPath.row)
        cell.delegate = self
        return cell
    }
}


// MARK: - UITableView Delegate
extension WishListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ProductLandscapeTVCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let closeAction = UIAlertAction(title: "Close", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.viewModel.removeFromWishList(at: indexPath.row)
        }
        
        Alert.show(on: self, title: "Wishlist", message: "Are you sure you want to delete from wishlist?", actions: [deleteAction, closeAction])
    }
}


// MARK: - ProductLandscapeCellDelegate
extension WishListViewController: ProductLandscapeCellDelegate {
    func didDeleteProduct(withID id: Int) {
        let closeAction = UIAlertAction(title: "Close", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.viewModel.removeFromWishList(withProductID: id)
        }
        
        Alert.show(on: self, title: "Wishlist", message: "Are you sure you want to delete from wishlist?", actions: [deleteAction, closeAction])
    }
}
