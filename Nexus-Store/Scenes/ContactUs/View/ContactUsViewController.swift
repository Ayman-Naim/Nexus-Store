//
//  ContactUsViewController.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 29/10/2023.
//

import UIKit

class ContactUsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "ContactTableViewCell", bundle:nil), forCellReuseIdentifier: "contactCell")
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
            let cell =  tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
            cell.nameLabel.text = "Ahmed Ashraf"
            cell.emailLabel.text = "ahmed.ashraf.aa.as@gmail.com"
            cell.phoneLabel.text = "01271745476"
            cell.imgView.image = UIImage(named: "Ahmed")
            return cell
        case 1:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
            cell.nameLabel.text = "Ayman Mohamed"
            cell.emailLabel.text = "ayman_mohamed.naim@yahoo.com"
            cell.phoneLabel.text = "01228424243"
            cell.imgView.image = UIImage(named: "Ayman")
            return cell
        case 2:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
            cell.nameLabel.text = "Mohamed Khater"
            cell.emailLabel.text = "ahmed.ashraf.aa.as@gmail.com"
            cell.phoneLabel.text = "01206338750"
            cell.imgView.image = UIImage(named: "khater")
            return cell
        case 3:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
            cell.nameLabel.text = "Mustafa Adel"
            cell.emailLabel.text = "ahmed.ashraf.aa.as@gmail.com"
            cell.phoneLabel.text = "01018710388"
            cell.imgView.image = UIImage(named: "Mustafa")
            return cell
        default:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
            cell.nameLabel.text = "Nexus-Store"
            cell.imgView.image = UIImage(named: "AppIcon")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
 
}
