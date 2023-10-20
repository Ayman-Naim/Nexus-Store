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
        nav.navigationBar.prefersLargeTitles = true
        if let sheet = nav.presentationController as? UISheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 40
        }
        return nav
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Order List"
        
        tableView.separatorStyle = .none
        tableView.register(ProductLandscapeTVCell.nib(), forCellReuseIdentifier: ProductLandscapeTVCell.identifier)
    }
}


// MARK: - UITableView DataSource & Delegate
extension ProductsOrderSheetTVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductLandscapeTVCell.identifier, for: indexPath) as! ProductLandscapeTVCell
        cell.showAsOrder()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ProductLandscapeTVCell.height
    }
}
