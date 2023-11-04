//
//  PromoCodesTableViewController.swift
//  Nexus-Admin
//
//  Created by Khater on 03/11/2023.
//

import UIKit

class PromoCodesTableViewController: UITableViewController {
    
    private let viewModel = PromoCodesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(PromoCodeTableViewCell.nib(), forCellReuseIdentifier: PromoCodeTableViewCell.idenifier)
        
        bindViewModel()
        viewModel.fetchPriceRules()
    }
    
    
    private func bindViewModel() {
        viewModel.reload = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.errorAlert = { [weak self] title, message in
            guard let self = self else { return }
            Alert.show(on: self, title: title, message: message)
        }
    }
}



// MARK: - UITableView DataSource
extension PromoCodesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PromoCodeTableViewCell.idenifier, for: indexPath) as! PromoCodeTableViewCell
        viewModel.configPromoCode(cell, at: indexPath.row)
        return cell
    }
}



// MARK: - UITableView Delegate
extension PromoCodesTableViewController {
}
