//
//  SearchViewController.swift
//  Nexus-Store
//
//  Created by Khater on 22/10/2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    static func present(on vc: UIViewController) {
        let nav = UINavigationController(rootViewController: SearchViewController())
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        vc.present(nav, animated: true)
    }
    
    
    private let searchTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Search.."
        textField.backgroundColor = .systemGray5
        textField.returnKeyType = .search
        return textField
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: "Background")
        return collectionView
    }()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor(named: "Background")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        setupCollectionView()
        
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
    }
    
    private func setupComponents() {
        self.view.addSubview(searchTextField)
        self.view.addSubview(cancelButton)
        self.view.addSubview(collectionView)
        
        // SearchTextField Constraints
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 18),
            searchTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 18),
            searchTextField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        // CancelButton Constraints
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: searchTextField.topAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -18),
            cancelButton.heightAnchor.constraint(equalTo: searchTextField.heightAnchor)
        ])
        
        // CollectionView Constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 18),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    
    private func setupCollectionView() {
        collectionView.setCollectionViewLayout(createCollectionViewLayout(), animated: true)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: K.customProductDetailsIdetifier, bundle: nil), forCellWithReuseIdentifier: K.customProductDetailsIdetifier)
    }
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let topInset: CGFloat = 10
        let bottomInset: CGFloat = 5
        let leadingInset: CGFloat = 5
        let trailingInset: CGFloat = 5
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: leadingInset, bottom: bottomInset, trailing: trailingInset)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(240))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      
        // Section
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }

    
    @objc private func cancelButtonClicked() {
        self.dismiss(animated: true)
    }
    
    deinit {
        print("SearchViewController deinit")
    }
}


// MARK: - UICollectionView DataSource & Delegate
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.customProductDetailsIdetifier, for: indexPath) as! productDetailsCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name:ProductDetailsViewController.storyBoardName , bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ProductDetailsViewController.identifier) as! ProductDetailsViewController
//         vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//         vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchTextField.resignFirstResponder()
    }
}

