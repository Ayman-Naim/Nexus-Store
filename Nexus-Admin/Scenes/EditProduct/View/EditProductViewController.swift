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
    @IBOutlet weak var colorsButton: UIButton!
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        setupView()
        setupColorsButton()
        
        
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
        } else if !sizeTextField.isHidden && !colorsButton.isHidden {
            if sizeTextField.text!.isEmpty {
                Alert.show(on: self, title: "Size", message: "The size can't be empty!")
            } else {
                viewModel?.editProduct(type: editType, value: sizeTextField.text!, colorsButton.titleLabel?.text ?? "red")
            }
        } else {
            // Handle Cases: .productType
            let selectedProductType = ProductType.allCases[segmentControl.selectedSegmentIndex].rawValue
            viewModel?.editProduct(type: editType, value: selectedProductType)
        }
    }
    
    @objc private func didTapOnView() {
        view.endEditing(true)
    }
    
    private func selectedColor(_ color: String) {
        print(color)
        colorsButton.titleLabel?.text = color
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
            colorsButton.isHidden = true
            
        case .description(let description):
            title = "Product Description"
            textView.text = description
            segmentControl.isHidden = true
            imageView.isHidden = true
            sizeTextField.isHidden = true
            colorsButton.isHidden = true
            
        case .productType(let productType):
            title = "Product Type"
            textView.isHidden = true
            imageView.isHidden = true
            sizeTextField.isHidden = true
            colorsButton.isHidden = true
            segmentControl.removeAllSegments()
            for index in ProductType.allCases.indices {
                segmentControl.insertSegment(withTitle: ProductType.allCases[index].rawValue, at: index, animated: true)
            }
            segmentControl.selectedSegmentIndex = ProductType.allCases.firstIndex(of: productType) ?? 0
            
        case .addImage:
            title = "Add New Image"
            segmentControl.isHidden = true
            sizeTextField.isHidden = true
            colorsButton.isHidden = true
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
    
    
    private func setupColorsButton() {
        let colors: [String] = ["red", "green", "blue", "orange", "yellow", "pink", "purple", "gray", "white", "black"]
        
        let colorsActions = colors.map({ UIAction(title: $0) { action in
            self.selectedColor(action.title)
        } })
        
        let colorMenuItems = UIMenu(title: "", options: .displayInline, children: colorsActions)
        
        colorsButton.menu = colorMenuItems
        colorsButton.titleLabel?.text = colors.first
        colorsButton.showsMenuAsPrimaryAction = true
        colorsButton.changesSelectionAsPrimaryAction = true
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
