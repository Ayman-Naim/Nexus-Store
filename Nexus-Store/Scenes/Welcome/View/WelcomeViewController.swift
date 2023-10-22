//
//  WelcomeViewController.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 19/10/2023.
//

import UIKit

class WelcomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SocialTableViewCell", bundle: nil), forCellReuseIdentifier: "welcomeCell")

        // Do any additional setup after loading the view.
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "welcomeCell", for: indexPath) as! SocialTableViewCell

        if(indexPath.row == 0){
            cell.imgView.image = UIImage(named: "facebook1")
            cell.labelSocial.text = "Continue With Facebook"
        } else if(indexPath.row == 1){
            cell.imgView.image = UIImage(named: "google1")
            cell.labelSocial.text = "Continue With Google"
        } else{
            cell.imgView.image = UIImage(named: "Applle")
            cell.labelSocial.text = "Continue With Apple"
        }
        return cell
    }
    /*
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return 10
        }*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
