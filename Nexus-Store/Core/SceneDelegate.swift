//
//  SceneDelegate.swift
//  Nexus-Store
//
//  Created by ayman on 17/10/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

/*    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        URLContexts.forEach { context in
            if context.url.scheme?.localizedCaseInsensitiveCompare("EOA-industry.Nexus-Store.payments") == .orderedSame {
                BTAppContextSwitcher.handleOpenURL(BTAppContextSwitcher.sharedInstance.handleOpenURL(context: context))
            }
        }
    }*/

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
      
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = SplashNexusScreen()
       
        window.makeKeyAndVisible()
        self.window = window
        
//        if UserDefaults.standard.object(forKey: "customerID") != nil {
//            //Key exists
//
//            guard let windowScene = (scene as? UIWindowScene) else { return }
//            let window = UIWindow(windowScene: windowScene)
//            // let nav = UINavigationController(rootViewController: SignInViewController())
//       //     let nav = UINavigationController(rootViewController: NexusTabBarController())
//            window.rootViewController = NexusTabBarController()
//            window.makeKeyAndVisible()
//            self.window = window
//        }else{
//            guard let windowScene = (scene as? UIWindowScene) else { return }
//            let window = UIWindow(windowScene: windowScene)
//            let nav = UINavigationController(rootViewController: SignInViewController())
//     //       let nav = UINavigationController(rootViewController: NexusTabBarController())
//            window.rootViewController = nav
//            window.makeKeyAndVisible()
//            self.window = window
//        }
//        guard let scene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(windowScene: scene)
//        let rootViewController = SplashNexusScreen()
//        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
//        window?.makeKeyAndVisible()
        
        InternetMointor.shared.start { [weak self] isConnected in
            guard let self = self else { return }
            print("Internet Connections \(isConnected)")
            if !isConnected {
//                DispatchQueue.main.async {
//                    print("adfadfasdfasdfasdfasdf")
//                    print(self.window?.rootViewController?.presentedViewController)
//                    if let viewController = self.window?.rootViewController?.presentedViewController {
//                        print(viewController is HomeViewController)
//                        let closeAction = UIAlertAction(title: "Close", style: .cancel)
//                        let goToSettingsAction = UIAlertAction(title: "Go to Settings", style: .default) { _ in
//                            let application = UIApplication.shared
//                            if let url = URL(string: UIApplication.openSettingsURLString), application.canOpenURL(url)    {
//                                application.open(url, options: [:], completionHandler: nil)
//                            }
//                        }
//                        Alert.show(on: viewController,
//                                   title: "Internet Connection",
//                                   message: "You are currently not connected to the internet, Check connection!",
//                                   actions: [closeAction, goToSettingsAction])
//                    }
//                }
            } else {
                //                DispatchQueue.main.async {
                //                    if let viewController = self.window?.rootViewController?.presentedViewController {
                //                        viewController.viewDidLoad()
                //                    }
                //                }
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

