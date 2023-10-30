//
//  EditProductViewController.swift
//  Nexus-Admin
//
//  Created by Khater on 28/10/2023.
//

import UIKit

class EditProductViewController: UIViewController {
    
    static func show(on vc: UIViewController, editingOn type: EditType, productID: Int) {
        let editProductVC = EditProductViewController()
        editProductVC.editType = type
        editProductVC.viewModel = EditProductViewModel(productID: productID)
        vc.navigationController?.pushViewController(editProductVC, animated: true)
    }
    
    enum EditType {
        case title(String)
        case productType(ProductType)
        case description(String)
        case addImage
        case addSizeColor
    }
    
    // MARK: - Properites
    private var editType: EditType?
    private var viewModel: EditProductViewModel?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        setupView()
        
        viewModel?.saved = { [weak self] isSaved in
            guard let self = self else { return }
            if isSaved {
                let closeAction = UIAlertAction(title: "Close", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                Alert.show(on: self, title: "Success", message: "Data is saved successfully", actions: [closeAction])
            }
        }
        
        viewModel?.error = { [weak self] errorMessage in
            guard let self = self else { return }
            Alert.show(on: self, title: "Error", message: errorMessage)
        }
        
        viewModel?.loading = { [weak self] isLoading in
            self?.isLoadingIndicatorAnimating = isLoading
            self?.view.isUserInteractionEnabled = !isLoading
        }
    }
    
    
    
    // MARK: - IBActions
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let editType = editType else { return }
        if !textView.isHidden {
            // Handle Cases: .title .productType .description .addImag
            if textView.text.isEmpty {
                Alert.show(on: self, title: "Text Field Error", message: "The text field can't be empty!")
            } else {
                viewModel?.editProduct(type: editType, value: textView.text!)
            }
        } else if !sizeTextField.isHidden && !colorTextField.isHidden {
            if sizeTextField.text!.isEmpty || colorTextField.text!.isEmpty {
                Alert.show(on: self, title: "Size & Color", message: "The size or color can't be empty!")
            } else {
                viewModel?.editProduct(type: editType, value: sizeTextField.text!, colorTextField.text!)
            }
        } else {
            // Handle Cases: .productType
            let selectedProductType = ProductType.allCases[segmentControl.selectedSegmentIndex].rawValue
            viewModel?.editProduct(type: editType, value: selectedProductType)
        }
    }
    
    
    // MARK: - Functions
    private func setupView() {
        guard let editType = editType else { return }
        textView.text = ""
        
        switch editType {
        case .title(let productTitle):
            title = "Product Title"
            textView.text = productTitle
            segmentControl.isHidden = true
            imageView.isHidden = true
            sizeTextField.isHidden = true
            colorTextField.isHidden = true
            
        case .description(let description):
            title = "Product Description"
            textView.text = description
            segmentControl.isHidden = true
            imageView.isHidden = true
            sizeTextField.isHidden = true
            colorTextField.isHidden = true
            
        case .productType(let productType):
            title = "Product Type"
            textView.isHidden = true
            imageView.isHidden = true
            sizeTextField.isHidden = true
            colorTextField.isHidden = true
            segmentControl.removeAllSegments()
            for index in ProductType.allCases.indices {
                segmentControl.insertSegment(withTitle: ProductType.allCases[index].rawValue, at: index, animated: true)
            }
            segmentControl.selectedSegmentIndex = ProductType.allCases.firstIndex(of: productType) ?? 0
            
        case .addImage:
            title = "Add New Image"
            segmentControl.isHidden = true
            sizeTextField.isHidden = true
            colorTextField.isHidden = true
            textView.delegate = self
            textView.text = "Add image URL here..."
            
        case .addSizeColor:
            title = "Add New Size & Image"
            segmentControl.isHidden = true
            textView.isHidden = true
            imageView.isHidden = true
        }
    }
    
    private func setupTapGesture() {
        let tapG = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        self.view.addGestureRecognizer(tapG)
    }
    
    @objc private func didTapOnView() {
        view.endEditing(true)
    }
}


// MARK: - UITextView Delegate
extension EditProductViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "Add image URL here..." {
            textView.text = ""
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        imageView.setImage(withURLString: textView.text)
    }
}
