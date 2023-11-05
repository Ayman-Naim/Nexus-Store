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
    let currencyOptions = ["USD", "EGP"]
    let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "SettingsTableViewCell", bundle:nil), forCellReuseIdentifier: "settingsCell")
        pickerView.delegate = self
        pickerView.dataSource = self
 //       pickerView.selectRow(0, inComponent: 0, animated: true)
        navigationItem.backAction  = UIAction(handler: { _ in
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
 //       pickerView.selectRow(0, inComponent: 0, animated: true)
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
            showCurrencyPicker()
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

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return currencyOptions.count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return currencyOptions[row]
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            // Handle the selection of a row in the UIPickerView if needed
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            // Handle the selected currency here
            if selectedRow == 0 {
                print("USD selected")
                setSelectedCurrency(isUSD: true)
                
            } else if selectedRow == 1 {
                print("EGP selected")
                setSelectedCurrency(isUSD: false)
            }
        }
    func showCurrencyPicker() {
        // Retrieve the previously selected currency from UserDefaults
            if let isUSD = UserDefaults.standard.value(forKey: "USD") as? Bool {
                let previouslySelectedRow = isUSD ? 0 : 1
                pickerView.selectRow(previouslySelectedRow, inComponent: 0, animated: false)
            }
        
        let alert = UIAlertController(title: "Change Currency", message: "Choose your currency:", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            let selectedRow = self?.pickerView.selectedRow(inComponent: 0)
            let selectedCurrency = self?.currencyOptions[selectedRow ?? 0]
            // Handle the selected currency as needed
            if let selectedCurrency = selectedCurrency {
                // Display a message with the selected currency
                let message = "You chose currency: \(selectedCurrency)"
                let resultAlert = UIAlertController(title: "Change Currency", message: message, preferredStyle: .alert)
                resultAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self?.navigateToRoot()
                }))
                self?.present(resultAlert, animated: true, completion: nil)
            }
        })

        alert.view.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        pickerView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 50).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -50).isActive = true

        present(alert, animated: true, completion: nil)
    }
    
    
    
    func setSelectedCurrency(isUSD: Bool){
        UserDefaults.standard.set(isUSD, forKey: "USD")
    }
    
    func navigateToRoot(){
             let cartVC =  CartViewController()
         self.navigationController?.pushViewController(cartVC, animated: true)
         
    }
    
}
