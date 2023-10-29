//
//  SettingsViewController.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 28/10/2023.
//

import UIKit

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
        return 4
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
            cell.settingsLabel.text = "Currency"
            cell.imgView.image = UIImage(named: "dosign")
            return cell
        case 2:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
            cell.settingsLabel.text = "Address"
            cell.imgView.image = UIImage(named: "address")
            return cell
        case 3:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
            cell.settingsLabel.text = "Logout"
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
        return 75
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            let aboutUsVC = AboutUsViewController()
            self.navigationController?.pushViewController(aboutUsVC, animated: true)
        case 1:
            let currencyVC = SignInViewController()
            self.navigationController?.pushViewController(currencyVC, animated: true)
        case 2:
            let addressVC = AddAddressViewController()
            self.navigationController?.pushViewController(addressVC, animated: true)
        case 3:
            let signinVC = SignInViewController()
      //      self.navigationController?.pushViewController(signinVC, animated: true)
            self.navigationController?.setViewControllers([signinVC], animated: true)
        default:
            print("Default")
        }
    }

}
