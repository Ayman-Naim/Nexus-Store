//
//  ProductsOrderSheetTVC.swift
//  Nexus-Store
//
//  Created by Khater on 20/10/2023.
//

import UIKit

class ProductsOrderSheetTVC: UITableViewController {
    
    static func sheet() -> UINavigationController {
        let nav = UINavigationController(rootViewController: ProductsOrderSheetTVC())
        //nav.navigationBar.prefersLargeTitles = true
        if let sheet = nav.presentationController as? UISheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 40
        }
        return nav
    }
    
    private init() {
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Order Details"
        
        tableView.separatorStyle = .none
        tableView.register(AddressTableViewCell.nib(), forCellReuseIdentifier: AddressTableViewCell.identifier)
        tableView.register(ProductLandscapeTVCell.nib(), forCellReuseIdentifier: ProductLandscapeTVCell.identifier)
        tableView.allowsSelection = false
    }
}


// MARK: - UITableView DataSource & Delegate
extension ProductsOrderSheetTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 5
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.identifier, for: indexPath) as! AddressTableViewCell
            cell.selecteAddress(true)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductLandscapeTVCell.identifier, for: indexPath) as! ProductLandscapeTVCell
            cell.hideButtons()
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
