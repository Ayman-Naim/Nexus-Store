//
//  SplashNexusScreen.swift
//  Nexus-Store
//
//  Created by Mustafa on 01/11/2023.
//

//
//  SplashVC.swift
//  SportsApp
//
//  Created by Abdallah on 06/10/2023.
//

import UIKit
import Lottie

class SplashNexusScreen: UIViewController {
    
    let myView : LottieAnimationView = .init()
    //let myView2 : LottieAnimationView = .init()
    let label = UILabel()
         
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myView.animation = .named("NexusShopping")
        myView.loopMode = .loop
        myView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        myView.center = view.center
        view = myView
        NSLayoutConstraint.activate([
            myView.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -100),
            // Adjust the constant value for desired spacing
               ])
        myView.contentMode = .scaleAspectFit
        myView.play()
        label.text = "Nexus Store"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 40, weight: .medium, width: .standard)
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        myView.addSubview(label)
        
        // Add constraints for label positioning within the view
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: myView.centerXAnchor),
            label.topAnchor.constraint(equalTo: myView.centerYAnchor, constant: 120) // Adjust the constant value for desired spacing
               ])
       
        myView.backgroundColor = .white
        
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(showFirstView), userInfo: nil, repeats: false)
    }
    
    @objc func showFirstView(){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        // Instantiate the initial view controller from the storyboard
//        let rootViewController = storyboard.instantiateInitialViewController()
//
//        if let navigationController = rootViewController as? UINavigationController {
//
//            let navigationBarAppearance = navigationController.navigationBar
//
//            navigationBarAppearance.tintColor = UIColor.black
//            navigationBarAppearance.setBackgroundImage(UIImage(), for: .default)
//            navigationBarAppearance.shadowImage = UIImage()
//            navigationBarAppearance.isTranslucent = true
//            // Set the font and text attributes for the navigation bar title
//            let titleTextAttributes: [NSAttributedString.Key: Any] = [
//                .foregroundColor: UIColor.black, // Set the text color to white
//                .font: UIFont.systemFont(ofSize: 25, weight: .bold) // Set the font and size
//            ]
//            navigationBarAppearance.titleTextAttributes = titleTextAttributes
//
//
//        }
//        
//        let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
//        sceneDelegate?.window?.rootViewController = rootViewController
//        sceneDelegate?.window?.makeKeyAndVisible()
//       
//        
//
        
        guard let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate else { return }
        
        if UserDefaults.standard.object(forKey: "customerID") != nil {
            sceneDelegate.window?.rootViewController = NexusTabBarController()
            sceneDelegate.window?.makeKeyAndVisible()
        }else{
            let nav = UINavigationController(rootViewController: SignInViewController())
            sceneDelegate.window?.rootViewController = nav
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
}




