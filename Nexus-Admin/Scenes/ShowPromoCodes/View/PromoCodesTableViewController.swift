//
//  PromoCodesTableViewController.swift
//  Nexus-Admin
//
//  Created by Khater on 03/11/2023.
//

import UIKit

class PromoCodesTableViewController: UIViewController {
    
    private let viewModel = PromoCodesViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Promo Codes"
        self.addProductButton()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PromoCodeTableViewCell.nib(), forCellReuseIdentifier: PromoCodeTableViewCell.idenifier)
        
        bindViewModel()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchPriceRules()
    }
    @objc func addProductToBrand(){
        self.navigationController?.pushViewController(AddPromoCodeViewController(), animated: true)
    }
    func addProductButton(){
        
        let addProduct = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addProductToBrand))
        
        navigationItem.rightBarButtonItem = addProduct
        
    }
    
    
    private func bindViewModel() {
        viewModel.reload = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.errorAlert = { [weak self] title, message in
            guard let self = self else { return }
            Alert.show(on: self, title: title, message: message)
        }
    }
}



// MARK: - UITableView DataSource
extension PromoCodesTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfRows == 0{
            self.tableView.backgroundView = emptyView()
            
        }else{
            self.tableView.backgroundView = nil
        }
        return viewModel.numberOfRows
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PromoCodeTableViewCell.idenifier, for: indexPath) as! PromoCodeTableViewCell
        viewModel.configPromoCode(cell, at: indexPath.row)
        return cell
    }
    
    func emptyView()-> UIView {
        let emptyTableViewBackgroundView = UIView(frame: self.tableView.bounds)

        let backgroundImageView = UIImageView(image: UIImage(named: "empty_1"))
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.frame = emptyTableViewBackgroundView.bounds
        emptyTableViewBackgroundView.addSubview(backgroundImageView)
        

        let messageLabel = UILabel()
        messageLabel.text = "Promo Code is Empty  "
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



// MARK: - UITableView Delegate
extension PromoCodesTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.viewModel.deletePriceRule(at: indexPath.row)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        Alert.show(on: self, title: "Delete Copon", message: "Are you sure, you want to delete copon!", actions: [cancelAction, deleteAction])
    }
}
