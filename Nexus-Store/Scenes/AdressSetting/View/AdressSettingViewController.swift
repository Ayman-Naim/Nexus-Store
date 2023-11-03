//
//  AdressSettingViewController.swift
//  Nexus-Store
//
//  Created by ayman on 03/11/2023.
//

import UIKit

class AdressSettingViewController: UIViewController {

    var viewModel = AdressSettingVM()
    @IBOutlet weak var AdressSettingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupTableview()
        SetupAddButoon()
        getUserAdresses()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUserAdresses()
    }
    // setup table view
    func SetupTableview(){
        title = "Addresses"
        AdressSettingTableView.delegate =  self
        AdressSettingTableView.dataSource = self
        AdressSettingTableView.register(UINib(nibName:"AddressTableViewCell" , bundle: nil), forCellReuseIdentifier: AddressTableViewCell.identifier)
    }
    //setup Add adress button
    func SetupAddButoon(){
        let add = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action:#selector(AddAdress))
        navigationItem.rightBarButtonItem = add
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }
    //setup the naviagton of add button
    @objc func AddAdress(){
        self.navigationController?.pushViewController(AddAddressViewController(), animated: true)
    }
    // get the addresses of the user 
    func getUserAdresses(){
        self.isLoadingIndicatorAnimating = true
        viewModel.getUserAdresses { result in
            switch result {
            case.success(_):
                //print("address fetched")
                self.AdressSettingTableView.reloadData()
                self.isLoadingIndicatorAnimating = !self.isLoadingIndicatorAnimating
            case.failure(let error):
                print(error)
                
            }
        }
        
    }
    

}
//MARK: table view Data source
extension AdressSettingViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.UserAdresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.identifier,for: indexPath) as? AddressTableViewCell
        cell?.addressLabel.text = viewModel.UserAdresses[indexPath.row].address1 ?? "Empty"
        cell?.nameLabel.text = viewModel.UserAdresses[indexPath.row].name ?? "Empty"
        return cell ?? UITableViewCell()
       
    }
    
  
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if(viewModel.UserAdresses[indexPath.row].isDefault == true ){
                DefaultAlert()
            }
            else{
                self.DelteAlert(Index: indexPath)
                
            }
            
            
        }
    }
    
    
    func DelteAlert(Index:IndexPath){
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want Delete this Address", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            self.isLoadingIndicatorAnimating = true
            self.viewModel.DelteAdress(addressID: self.viewModel.UserAdresses[Index.row].id) { result  in
                switch result {
                case.success(_):
                    self.isLoadingIndicatorAnimating = !self.isLoadingIndicatorAnimating
                    self.viewModel.UserAdresses.remove(at:Index.row)
                    self.AdressSettingTableView.deleteRows(at: [Index], with: .fade)
                    
                case.failure(let error):
                 
                        print(error)
                }
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func DefaultAlert(){
        let alert = UIAlertController(title: "Delete", message: "You cant delte the default address", preferredStyle: .alert)
      
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
