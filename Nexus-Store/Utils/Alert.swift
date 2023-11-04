//
//  Alert.swift
//  Nexus-Store
//
//  Created by Khater on 20/10/2023.
//

import UIKit


struct Alert {
    
    private init() {}
    
    static func show(on vc: UIViewController, title: String, message: String, actions: [UIAlertAction]? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if let actions = actions {
                for action in actions {
                    alert.addAction(action)
                }
            } else {
                alert.addAction(UIAlertAction(title: "Close", style: .destructive))
            }
            
            vc.present(alert, animated: true)
        }
    }
    
    static func loginAlert(on vc: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Sign In", message: "You need to login first.", preferredStyle: .alert)
            
            let closeAction = UIAlertAction(title: "Close", style: .destructive)
            let signInAction = UIAlertAction(title: "Sign In", style: .default) { _ in
                
                UserDefaults.standard.removeObject(forKey: "customerID")
                UserDefaults.standard.removeObject(forKey: "customerEmail")
                UserDefaults.standard.synchronize()

                
                if let sceneDelegate = UIApplication.shared.connectedScenes
                    .first!.delegate as? SceneDelegate {
                    let nav = UINavigationController(rootViewController: SignInViewController())
                    sceneDelegate.window!.rootViewController = nav
                }

               // vc.navigationController?.pushViewController(SignInViewController(), animated: true)
            }
            
            alert.addAction(closeAction)
            alert.addAction(signInAction)
            vc.present(alert, animated: true)
        }
    }
}
