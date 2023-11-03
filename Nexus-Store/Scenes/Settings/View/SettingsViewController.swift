//
//  SettingsViewController.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 28/10/2023.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "SettingsTableViewCell", bundle:nil), forCellReuseIdentifier: "settingsCell")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
            cell.settingsLabel.text = "About US"
            cell.imgView.image = UIImage(named: "about us")
            return cell
        case 1:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
            cell.settingsLabel.text = "Contact US"
            cell.imgView.image = UIImage(named: "contactUs")
            return cell
        case 2:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
            cell.settingsLabel.text = "Currency"
            cell.imgView.image = UIImage(named: "dosign")
            return cell
        case 3:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
            cell.settingsLabel.text = "Address"
            cell.imgView.image = UIImage(named: "address")
            return cell
        case 4:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
            cell.settingsLabel.text = "Sign Out"
            cell.imgView.image = UIImage(named: "logoutt")
            return cell
        default:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
            cell.settingsLabel.text = "Nexus-Store"
            cell.imgView.image = UIImage(named: "AppIcon")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            let aboutUsVC = AboutUsViewController()
            self.navigationController?.pushViewController(aboutUsVC, animated: true)
        case 1:
            let contactUsVC = ContactUsViewController()
            self.navigationController?.pushViewController(contactUsVC, animated: true)
        case 2:
            let currencyVC = SignInViewController()
            self.navigationController?.pushViewController(currencyVC, animated: true)
        case 3:
            let addressVC = AdressSettingViewController()
            self.navigationController?.pushViewController(addressVC, animated: true)
        case 4:
       //     let signinVC = SignInViewController()
            let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: { action in
                do{
                    try Auth.auth().signOut()
         //           self.signOutGoogle()
                    UserDefaults.standard.removeObject(forKey: "customerID")
                    UserDefaults.standard.removeObject(forKey: "customerEmail")
                    UserDefaults.standard.synchronize()
            //        self.navigationController?.setViewControllers([signinVC], animated: true)
                    if let sceneDelegate = UIApplication.shared.connectedScenes
                        .first!.delegate as? SceneDelegate {
                        let nav = UINavigationController(rootViewController: SignInViewController())
                        sceneDelegate.window!.rootViewController = nav
                    }
                } catch{
                    print("Logout Error: \(error.localizedDescription)")
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        default:
            print("Default")
        }
    }
    /*
    func signOutGoogle(){
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            GIDSignIn.sharedInstance.signOut()
        } catch{
            print("Logout Error: \(error.localizedDescription)")
        }
    }*/
}
