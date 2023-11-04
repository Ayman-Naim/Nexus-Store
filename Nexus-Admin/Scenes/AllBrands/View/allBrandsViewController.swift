//
//  allBrandsViewController.swift
//  Nexus-Admin
//
//  Created by ayman on 01/11/2023.
//

import UIKit

class allBrandsViewController: UIViewController {

    @IBOutlet weak var BrandTableView: UITableView!
    var brands:[SmartCollection]=[]
    var viewModel = AllBrandsVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All Brands"
        SetupTableview()
        getbrands()
        logoutButoonconfig()
        // Do any additional setup after loading the view.
    }

    func SetupTableview(){
        self.BrandTableView.delegate = self
        self.BrandTableView.dataSource = self
        self.BrandTableView.register(UINib(nibName: "BrandTableViewCell", bundle: nil), forCellReuseIdentifier: BrandTableViewCell.identifier)
    }
    
    func getbrands(){
        self.isLoadingIndicatorAnimating = true
        viewModel.getBrands { result  in
            switch result {
            case .success(let brands ):
                print(brands)
                self.brands = brands
                self.isLoadingIndicatorAnimating = !self.isLoadingIndicatorAnimating
                self.BrandTableView.reloadData()
            case .failure(let error ):
                print (error)
            }
        }
    }
    func cellConfig(cell : BrandTableViewCell ,IndexPath:IndexPath){
        
        cell.brandImage.setImage(withURLString: self.brands[IndexPath.row].image?.src ?? "")
        cell.brandName.text = self.brands[IndexPath.row].title
    }
   
    @objc func Logoutpressed(){
        guard let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate else { return }
        let nav =  UINavigationController(rootViewController: SignInViewController())

            sceneDelegate.window?.rootViewController = nav
            sceneDelegate.window?.makeKeyAndVisible()
        UserDefaults.standard.removeObject(forKey: "Admin")
    }
    func logoutButoonconfig(){
        
        let logout = UIBarButtonItem(title:"Log out", style: .plain, target: self, action: #selector(Logoutpressed))
        
        navigationItem.leftBarButtonItem = logout
        
    }

}

extension allBrandsViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.brands.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BrandTableViewCell.identifier) as? BrandTableViewCell
        
        self.cellConfig(cell: cell!, IndexPath: indexPath)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let brandId  = self.brands[indexPath.row].id  else {return }
        let brandViewModel = BrandProductViewModel(brandId: brandId)
        let vc = BrandProductsViewController()
        vc.brandProductDelegation = brandViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
