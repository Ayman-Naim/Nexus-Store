//
//  TabBarViewController.swift
//  Nexus-Admin
//
//  Created by ayman on 04/11/2023.
//
//
//  NexusTabBarController.swift
//  Nexus-Store
//
//  Created by Khater on 21/10/2023.
//

import UIKit

class NexusAdminTabBarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        setupViewControllers()
        setupNavigationAppearance()
        self.delegate = self
    }
    
    private  func setupViewControllers() {
        let vc = [
            createNavigationController(withRoot: allBrandsViewController(), barTitle: "Brands", barImage: UIImage(systemName: "house")),
//            createNavigationController(withRoot: BrandProductsViewController(), barTitle: "Products", barImage: UIImage(systemName: "square.grid.2x2")),
            createNavigationController(withRoot: PromoCodesTableViewController(), barTitle: "Promo", barImage: UIImage(systemName: "barcode.viewfinder")),
        ]
        
        setViewControllers(vc, animated: true)
    }
    
    private func createNavigationController(withRoot vc: UIViewController, barTitle title: String?, barImage image: UIImage?) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        return nav
    }
    
    private func setupNavigationAppearance() {
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000.0, vertical: 0.0), for: .default)
        UINavigationBar.appearance().tintColor = .label
//        UINavigationBar.appearance().titleTextAttributes = [
//            .foregroundColor: UIColor.label, // Set the text color to white
//            .font: UIFont.systemFont(ofSize: 32, weight: .regular) // Set the font and size
//        ]
    }
    
    private func setupTabBarAppearance() {
        UITabBar.appearance().tintColor = .label
        UITabBar.appearance().backgroundColor = .secondarySystemBackground
    }
    
    
    
   
}
