//
//  ProfileViewController.swift
//  Nexus-Store
//
//  Created by ayman on 19/10/2023.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet weak var UserName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TableView.separatorColor = UIColor.clear
        setupTabelView()
        circleImage()
        // Do any additional setup after loading the view.
    }


    func setupTabelView(){
        TableView.delegate = self
        TableView.dataSource =  self
        TableView.register(UINib(nibName: "FavouriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavouriteTableViewCell")
        TableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        TableView.register(UINib(nibName: "SectionHeaderTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "SectionHeaderTableViewCell")
  
    }
    
    func circleImage(){
        self.UserImage.layer.cornerRadius = self.UserImage.frame.size.width/2;
        self.UserImage.layer.masksToBounds = true
        self.UserImage.contentMode = .scaleAspectFill
        
    }
    
    
    @IBAction func CartButtonClicked(_ sender: Any) {
        self.navigationController?.pushViewController(CartViewController(), animated: true)
    }
    
    @IBAction func WishListClicked(_ sender: Any) {
        //
    }
}

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case  0 :
            let cell  = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as!  OrderTableViewCell
            return cell
           
        case  1 :
            let cell  = tableView.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell", for: indexPath) as!  FavouriteTableViewCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section{
        case 0:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderTableViewCell") as! SectionHeaderTableViewCell
            headerView.HeaderTitle.text = "My Orders"
               return headerView
            
            
         

        case 1:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderTableViewCell") as! SectionHeaderTableViewCell
            headerView.HeaderTitle.text = "Wish List"
               return headerView

        default:
            return UIView()

        }
    }
    
    
    
   
    
}
