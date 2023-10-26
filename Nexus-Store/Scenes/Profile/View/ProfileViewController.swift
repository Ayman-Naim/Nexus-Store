//
//  ProfileViewController.swift
//  Nexus-Store
//
//  Created by ayman on 19/10/2023.
//

import UIKit

class ProfileViewController: UIViewController {
    var ViewModel = ProfileVM()
    var orders = [Order]()
    var expandItemsSec1 = false
    var expandItemsSec2 = false
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet weak var UserName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TableView.separatorColor = UIColor.clear
        setupTabelView()
        circleImage()
        getOrders()
        self.isLoadingIndicatorAnimating = true
        // Do any additional setup after loading the view.
    }


    func setupTabelView(){
        TableView.delegate = self
        TableView.dataSource =  self
        TableView.register(UINib(nibName: "FavouriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavouriteTableViewCell")
        TableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        TableView.register(UINib(nibName: "SectionHeaderTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "SectionHeaderTableViewCell")
        self.setContentEmptyTitle("No products in the Cart! 🧐")
        self.setContentEmptyImage(UIImage(named: "empty_2"))
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
        switch section{
        case 0 :
            if (orders.count == 0) {
                return 0;
            } else if (expandItemsSec1 == false) {
                return 2;
            } else {
                return orders.count;
            }

        case 1 :
            return 0
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case  0 :
            let cell  = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as!  OrderTableViewCell
            if  orders.count>0{
                   cell.orderNo.text = "\(orders[indexPath.row].order_number!)"
                cell.quantity.text = "\(orders[indexPath.row].line_items!.count)"
                cell.totalAmount.text = "\(orders[indexPath.row].total_price!)\(orders[indexPath.row].currency=="EGP" ?" EGP":" $")"
                return cell
            }
            else{
                return cell
            }
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
            headerView.Delegate = self
            headerView.section = 0
               return headerView
            
            
         

        case 1:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderTableViewCell") as! SectionHeaderTableViewCell
            headerView.HeaderTitle.text = "Wish List"
            headerView.Delegate = self
            headerView.section = 1
               return headerView

        default:
            return UIView()

        }
    }
    
    
    
   
    
}



extension ProfileViewController:ProfileDelegete{
    func Seeallpressed(section: Int?) {
        if(section == 0){
            
            self.expandItemsSec1 = !self.expandItemsSec1
            self.TableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
        if(section == 1){
            self.expandItemsSec2 = true
        }
    }
    
  
    
  
    func getOrders(){
        ViewModel.getOrders { result in
            switch result{
            case .success(let orders):
                print(orders)
                self.orders = orders
                self.isLoadingIndicatorAnimating = !self.isLoadingIndicatorAnimating
                self.TableView.reloadSections(IndexSet(integer: 0), with: .fade)
                
            case .failure(let error):
                print(error)
                
                
            }
            
        }
    }
    
    
    
    
}
