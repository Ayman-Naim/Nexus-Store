//
//  ProductDetailsViewController.swift
//  Nexus-Admin
//
//  Created by Khater on 27/10/2023.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    static func show(on vc: UIViewController, productID: Int) {
        let productDetailsVC = ProductDetailsViewController()
        productDetailsVC.viewModel.setProductID(productID)
        vc.navigationController?.pushViewController(productDetailsVC, animated: true)
    }
    
    
    private let viewModel = ProductDetailsViewModel()
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var saveQuantityButton: UIButton!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var savePriceButton: UIButton!
    
    
    private init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        priceTextField.delegate = self
        addDoneButtonOnKeyboardToPriceTextField()
        setupImageCollectionView()
        setupSizeCollectionView()
        setupColorCollectionView()
        bindViewModel()
        
        
        if #available(iOS 16.0, *) {
            navigationItem.backAction  = UIAction(handler: { _ in
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 8031031165164
        viewModel.fetchProduct()
        
        if #available(iOS 16.0, *) {
            tabBarController?.tabBar.isHidden = true
        }
    }
    
    
    
    // MARK: - IBAction
    @IBAction func deleteImageButtonPressed(_ sender: UIButton) {
        viewModel.deleteImage(at: pageControl.currentPage)
    }
    
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        EditProductViewController.show(on: self, editingOn: .addImage, productID: viewModel.productID)
    }
    
    @IBAction func editTitleButtonPressed(_ sender: UIButton) {
        EditProductViewController.show(on: self, editingOn: .title(titleLabel.text!), productID: viewModel.productID)
    }
    
    @IBAction func editTypeButtonPressed(_ sender: UIButton) {
        EditProductViewController.show(on: self, editingOn: .productType(viewModel.productType), productID: viewModel.productID)
    }
    
    @IBAction func editDescriptionButtonPressed(_ sender: UIButton) {
        EditProductViewController.show(on: self, editingOn: .description(descriptionLabel.text!), productID: viewModel.productID)
    }
    
    @IBAction func quantityButtonPressed(_ sender: UIButton) {
        // Minus Button
        if sender.tag == 0 {
            viewModel.decrementQuantity()
        }
        
        // Plus Button
        if sender.tag == 1 {
            viewModel.incrementQuantity()
        }
    }
    
    @IBAction func saveQuantityButtonPressed(_ sender: UIButton) {
        viewModel.saveNewQuantity()
    }
    
    
    @IBAction func savePriceButtonPressed(_ sender: UIButton) {
        viewModel.savePrice(priceTextField.text)
    }
    
    @IBAction func deleteProductButtonPressed(_ sender: UIButton) {
        viewModel.deleteProduct()
    }
    @IBAction func addNewSizeColorButtonPressed(_ sender: UIButton) {
        EditProductViewController.show(on: self, editingOn: .addSizeColor, productID: viewModel.productID)
    }
    
    
    // MARK: - Functions
    private func setupImageCollectionView() {
        
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
        imageCollectionView.register(ProductImageCollectionViewCell.self, forCellWithReuseIdentifier: ProductImageCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        imageCollectionView.setCollectionViewLayout(layout, animated: true)
        imageCollectionView.isPagingEnabled = true
        imageCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupSizeCollectionView() {
        sizeCollectionView.dataSource = self
        sizeCollectionView.delegate = self
        sizeCollectionView.register(CircularCollectionViewCell.self, forCellWithReuseIdentifier: CircularCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 59, height: 59)
        layout.scrollDirection = .horizontal
        sizeCollectionView.setCollectionViewLayout(layout, animated: true)
        sizeCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupColorCollectionView() {
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.register(CircularCollectionViewCell.self, forCellWithReuseIdentifier: CircularCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 59, height: 59)
        layout.scrollDirection = .horizontal
        colorCollectionView.setCollectionViewLayout(layout, animated: true)
        colorCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func bindViewModel() {
        viewModel.reload = { [weak self] in
            guard let self = self else { return }
            self.imageCollectionView.reloadData()
            self.sizeCollectionView.reloadData()
            self.colorCollectionView.reloadData()
            //self?.sizeCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            //self?.colorCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            
            self.sizeCollectionView.performBatchUpdates {
                if self.viewModel.numberOfSizes > 0 {
                    self.sizeCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                }
            }
            
            self.colorCollectionView.performBatchUpdates {
                if self.viewModel.numberOfColor > 0 {
                    self.colorCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                }
            }
        }
        
        viewModel.error = { [weak self] errorMessage in
            guard let self = self else { return }
            Alert.show(on: self, title: "Error", message: errorMessage)
        }
        
        viewModel.updateUI = { [weak self] product in
            guard let self = self else { return }
            self.titleLabel.text = product.title
            self.descriptionLabel.text = product.description
            self.typeLabel.text = product.productType.rawValue
        }
        
        viewModel.updataPrice = { [weak self] price in
            self?.priceTextField.text = "\(price)"
        }
        
        viewModel.updateQuantity = { [weak self] quantity in
            self?.quantityLabel.text = quantity
        }
        
        viewModel.loading = { [weak self] isLoading in
            self?.isLoadingIndicatorAnimating = isLoading
            self?.view.isUserInteractionEnabled = !isLoading
        }
        
        viewModel.saved = { [weak self] isSaved in
            guard let self = self else { return }
            if isSaved {
                let closeAction = UIAlertAction(title: "Close", style: .default)
                Alert.show(on: self, title: "Success", message: "Data is saved successfully", actions: [closeAction])
            }
        }
        
        viewModel.hideSaveQuantityButton = { [weak self] isHidden in
            self?.saveQuantityButton.isHidden = isHidden
        }
        
        viewModel.hideSavePriceButton = { [weak self] isHidden in
            self?.savePriceButton.isHidden = isHidden
        }
        
        viewModel.goBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func updatePageControl() {
        if let visibleCell = imageCollectionView.visibleCells.first {
            if let visibleCellIndex = imageCollectionView.indexPath(for: visibleCell)?.item {
                pageControl.currentPage = visibleCellIndex
            }
        }
    }
    
    func addDoneButtonOnKeyboardToPriceTextField() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonActionPressed))
        
        //doneToolbar.sizeToFit()
        doneToolbar.items = [flexSpace, done]
        
        priceTextField.inputAccessoryView = doneToolbar
    }
    
    @objc private func doneButtonActionPressed() {
        priceTextField.resignFirstResponder()
    }
}


// MARK: - UICollectionView DataSource
extension ProductDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case imageCollectionView:
            pageControl.numberOfPages = viewModel.numberOfImages
            return viewModel.numberOfImages
        case sizeCollectionView:
            return viewModel.numberOfSizes
        case colorCollectionView:
            return viewModel.numberOfColor
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case imageCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCollectionViewCell.identifier, for: indexPath) as! ProductImageCollectionViewCell
            viewModel.imageFor(cell: cell, at: indexPath.item)
            return cell
        case sizeCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircularCollectionViewCell.identifier, for: indexPath) as! CircularCollectionViewCell
            viewModel.sizeFor(cell: cell, at: indexPath.item)
            return cell
        case colorCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircularCollectionViewCell.identifier, for: indexPath) as! CircularCollectionViewCell
            viewModel.colorFor(cell, at: indexPath.item)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case sizeCollectionView:
            viewModel.didSelectSize(at: indexPath.item)
        case colorCollectionView:
            viewModel.didSelectColor(at: indexPath.item)
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case imageCollectionView:
            return CGSize(width: imageCollectionView.frame.width, height: view.frame.height * 0.35)
        case sizeCollectionView, colorCollectionView:
            return CGSize(width: 59, height: 59)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard imageCollectionView == collectionView else { return }
        updatePageControl()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard imageCollectionView == collectionView else { return }
        updatePageControl()
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let deleteAction = UIAction(title: "Delete", attributes: .destructive, state: .off) { _ in
            let index = indexPaths[0].item
            switch collectionView {
            case self.sizeCollectionView:
                self.viewModel.deleteSize(at: index)
            case self.colorCollectionView:
                self.viewModel.deleteColor(at: index)
            default:
                break
            }
        }
        
        let menu = UIMenu(title: "", options: .destructive, children: [deleteAction])
        
        let config = UIContextMenuConfiguration(actionProvider: { _ in menu })
        return config
    }
}


// MARK: - UITextField Delegate
extension ProductDetailsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.priceDidChange(textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
