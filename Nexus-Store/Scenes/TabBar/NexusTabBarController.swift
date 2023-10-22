//
//  NexusTabBarController.swift
//  Nexus-Store
//
//  Created by Khater on 21/10/2023.
//

import UIKit

class NexusTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        setupViewControllers()
        setupNavigationAppearance()
    }
    
    private  func setupViewControllers() {
        let vc = [
            createNavigationController(withRoot: HomeViewController(), barTitle: "Home", barImage: UIImage(systemName: "house")),
            createNavigationController(withRoot: CategoryViewController(), barTitle: "Category", barImage: UIImage(systemName: "square.grid.2x2")),
            createNavigationController(withRoot: ProfileViewController(), barTitle: "Profile", barImage: UIImage(systemName: "person")),
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
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.label, // Set the text color to white
            .font: UIFont.systemFont(ofSize: 32, weight: .regular) // Set the font and size
        ]
    }
    
    private func setupTabBarAppearance() {
        UITabBar.appearance().tintColor = .label
        UITabBar.appearance().backgroundColor = .secondarySystemBackground
    }
}
