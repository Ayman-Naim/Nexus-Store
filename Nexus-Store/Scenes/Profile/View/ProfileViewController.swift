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
    var wishList: [Product] = []
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
        setUserName()
        CheckLogIn()
     
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        expandItemsSec1 = false
        expandItemsSec2 = false
        self.TableView.reloadData()
        CheckLogIn()
         
        
    }
    func CheckLogIn(){
        if K.customerID != -1{
            getOrders()
            getwishlist()
        }
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
        self.UserImage.layer.borderWidth = 1.5
        
    }
    
    
    @IBAction func CartButtonClicked(_ sender: Any) {
        if K.customerID == -1 {
            Alert.loginAlert(on: self)
        }
        else{
            self.navigationController?.pushViewController(CartViewController(), animated: true)
        }
    }
    
    @IBAction func WishListClicked(_ sender: Any) {
        if K.customerID == -1 {
            Alert.loginAlert(on: self)
        }
        else{
            self.navigationController?.pushViewController(SettingsViewController(), animated: true)
        }
    }
}

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if K.customerID == -1 {
            Alert.loginAlert(on: self)
            let emptyView = emptyView()
            tableView.backgroundView = emptyView
          
            return 0
        }else{
            switch section{
            case 0 :
                if (orders.count == 0) {
                    return 0;
                } else if (expandItemsSec1 == false) {
                    return orders.count==1 ? 1 : 2
                } else {
                    return orders.count;
                }
                
            case 1 :
                if (wishList.count == 0) {
                    return 0;
                } else if (expandItemsSec2 == false) {
                    return wishList.count==1 ? 1 : 2
                } else {
                    return wishList.count;
                }
                
                
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case  0 :
            
            let cell  = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as!  OrderTableViewCell
            cell.selectionStyle = .none
            if  orders.count>0{
                //if(orders[indexPath.row].customer?.id == 6899149603052){
                cell.orderNo.text = "\(orders[indexPath.row].order_number!)"
                cell.quantity.text = "\(orders[indexPath.row].line_items!.count)"
//                cell.totalAmount.text = "\(orders[indexPath.row].total_price!)\(orders[indexPath.row].currency=="EGP" ?" EGP":" $")"
                cell.totalAmount.text = ConvertPrice.share.changePrice(price: orders[indexPath.row].total_price ?? "")
                
                return cell
                // }
            }
            else{
                return cell
            }
        case  1 :
          
            let cell  = tableView.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell", for: indexPath) as!  FavouriteTableViewCell
            cell.selectionStyle = .none
            cell.productImage.setImage(withURLString: wishList[indexPath.row].image?.src ?? "")
            let title = wishList[indexPath.row].title
            cell.productName.text = title
            guard let price = wishList[indexPath.row].variants!.first?.price else{return cell}
//            cell.ProductPrice.text = "\(price) $"
            cell.ProductPrice.text = ConvertPrice.share.changePrice(price: price)
            
            return cell
        default:
            return UITableViewCell()
        }
        //return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if K.customerID == -1  {
           return nil
        }else {
            
            
            switch section{
            case 0:
                let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderTableViewCell") as! SectionHeaderTableViewCell
                headerView.HeaderTitle.text = "My Orders"
                headerView.Delegate = self
                headerView.section = 0
                self.expandItemsSec1 == true ? headerView.SeeAll.setTitle("See less", for: .normal):headerView.SeeAll.setTitle("See More", for: .normal)
                return headerView
                
                
                
                
            case 1:
                let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderTableViewCell") as! SectionHeaderTableViewCell
                headerView.HeaderTitle.text = "Wish List"
                headerView.Delegate = self
                headerView.section = 1
                self.expandItemsSec2 == true ? headerView.SeeAll.setTitle("See less", for: .normal):headerView.SeeAll.setTitle("See More", for: .normal)
                return headerView
                
            default:
                return nil //UIView()
                
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
            
        case 0 :
            guard let url = URL(string: orders[indexPath.row].order_status_url ?? "") else { return }
            UIApplication.shared.open(url)
        case 1 :
            let product = wishList[indexPath.row]
            let storyboard = UIStoryboard(name:ProductDetailsViewController.storyBoardName , bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ProductDetailsViewController.identifier) as! ProductDetailsViewController
            let productDetailsViewModel = ProductDetailsViewModel(for: product.id)
            vc.productDetailsViewModel = productDetailsViewModel
            vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        default:
            print("nothing")
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
            self.expandItemsSec2 = !self.expandItemsSec2
            self.TableView.reloadSections(IndexSet(integer: 1), with: .fade)
        }
    }
    
    
    
    
    func getOrders(){
        self.isLoadingIndicatorAnimating = true
        ViewModel.getOrders { result in
            switch result{
            case .success(let orders):
                print(orders)
                self.orders = orders.filter({ $0.customer?.id == K.customerID })
                self.isLoadingIndicatorAnimating = !self.isLoadingIndicatorAnimating
              
                self.TableView.reloadSections(IndexSet(integer: 0), with: .fade)
                
            case .failure(let error):
                print(error)
                
                
            }
            
        }
    }
    
    func getwishlist(){
        self.isLoadingIndicatorAnimating = true
        ViewModel.getWishlist(forCustom: K.customerID) { result in
            switch result{
            case .success(let wishLists):
                print(wishLists)
                self.wishList = wishLists
                self.isLoadingIndicatorAnimating = !self.isLoadingIndicatorAnimating
                self.TableView.reloadSections(IndexSet(integer: 1), with: .fade)
              
                
            case .failure(let error):
                print(error)
            }
        }
       
    }
    //get user name
    func setUserName(){
        let user = ViewModel.getUserData()
        switch user{
        case.success(let userEmail):
            UserName.text = userEmail
        case.failure(let error ):
            UserName.text = "User Guest"
            
        }
        
    }
    
    
    func emptyView()-> UIView {
        let emptyTableViewBackgroundView = UIView(frame: self.TableView.bounds)

        let backgroundImageView = UIImageView(image: UIImage(named: "empty_1"))
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.frame = emptyTableViewBackgroundView.bounds
        emptyTableViewBackgroundView.addSubview(backgroundImageView)
        

        let messageLabel = UILabel()
        messageLabel.text = "Histoy is Empty in Guest Mode \n You have to log in "
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = UIColor.black
        messageLabel.sizeToFit()
        messageLabel.frame = CGRect(x: 0, y: (backgroundImageView.frame.size.height/2 )-165, width: emptyTableViewBackgroundView.bounds.width - 40, height: 80)
      //  messageLabel.center = emptyTableViewBackgroundView.center
        emptyTableViewBackgroundView.addSubview(messageLabel)
       return  emptyTableViewBackgroundView
    }
}
