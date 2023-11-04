//
//  OrderDetailsSheetTVC.swift
//  Nexus-Store
//
//  Created by Khater on 20/10/2023.
//

import UIKit

class OrderDetailsSheetTVC: UITableViewController {
    
    static func sheet() -> UINavigationController {
        let nav = UINavigationController(rootViewController: OrderDetailsSheetTVC())
        //nav.navigationBar.prefersLargeTitles = true
        if let sheet = nav.presentationController as? UISheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 40
        }
        return nav
    }
    
    
    private let viewModel = OrderDetailsSheetViewModel()
    
    
    private init() {
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Order Details"
        setupTableView()
        bindViewModel()
        viewModel.fetchDefaultAddress()
        viewModel.fetchOrders()
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(AddressTableViewCell.nib(), forCellReuseIdentifier: AddressTableViewCell.identifier)
        tableView.register(ProductLandscapeTVCell.nib(), forCellReuseIdentifier: ProductLandscapeTVCell.identifier)
        tableView.allowsSelection = false
    }
    
    private func bindViewModel() {
        viewModel.reload = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.loadingIndicator = { [weak self] isLoading in
            self?.isLoadingIndicatorAnimating = isLoading
        }
        
        viewModel.errorOccure = { [weak self] title, message in
            guard let self = self else { return }
            Alert.show(on: self, title: title, message: message)
        }
    }
}


// MARK: - UITableView DataSource & Delegate
extension OrderDetailsSheetTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRow(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.identifier, for: indexPath) as! AddressTableViewCell
            viewModel.configAddress(cell)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductLandscapeTVCell.identifier, for: indexPath) as! ProductLandscapeTVCell
            viewModel.configProduct(cell, at: indexPath.row)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ProductLandscapeTVCell.height
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Shipping Address"
        case 1: return "Products"
        default: return nil
        }
    }
}
