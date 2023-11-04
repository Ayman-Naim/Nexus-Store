//
//  PromoCodesTableViewController.swift
//  Nexus-Admin
//
//  Created by Khater on 03/11/2023.
//

import UIKit

class PromoCodesTableViewController: UIViewController {
    
    private let viewModel = PromoCodesViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Promo Codes"
        
        tableView.delegate = self
        tableView.dataSource = self
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
extension PromoCodesTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.isContentEmptyViewHidden = viewModel.numberOfRows > 0
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PromoCodeTableViewCell.idenifier, for: indexPath) as! PromoCodeTableViewCell
        viewModel.configPromoCode(cell, at: indexPath.row)
        return cell
    }
}



// MARK: - UITableView Delegate
extension PromoCodesTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.viewModel.deletePriceRule(at: indexPath.row)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        Alert.show(on: self, title: "Delete Copon", message: "Are you sure, you want to delete copon!", actions: [cancelAction, deleteAction])
    }
}
