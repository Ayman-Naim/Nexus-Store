//
//  ProductDetailsViewModel.swift
//  Nexus-Admin
//
//  Created by Khater on 27/10/2023.
//

import Foundation
import Alamofire



class ProductDetailsViewModel {
    
    // MARK: - Properties
    public private(set) var productID: Int = 0
    var productType: ProductType { product!.productType }
    private var images: [Image] = []
    private var sizes: [String] = []
    private var colors: [String] = []
    private var selectedSize = 0
    private var selectedColor = 0
    
    private var product: Product? {
        didSet {
            DispatchQueue.main.async {
                if let product = self.product {
                    self.updateUI?(product)
                }
            }
        }
    }
    
    private var currentVariant: Variant? {
        didSet {
            guard let currentVariant = currentVariant else { return }
            currentQuantity = currentVariant.inventoryQuantity
            DispatchQueue.main.async {
                self.updataPrice?(currentVariant.price)
            }
        }
    }
    
    private var currentQuantity = 0 {
        didSet {
            DispatchQueue.main.async {
                self.updateQuantity?(String(self.currentQuantity))
                if let currentVariant = self.currentVariant {
                    self.hideSaveQuantityButton?(currentVariant.inventoryQuantity == self.currentQuantity)
                }
            }
        }
    }
    
    
    // MARK: - Clousers
    var reload: (() -> Void)?
    var error: ((String) -> Void)?
    var updateUI: ((Product) -> Void)?
    var updataPrice: ((String) -> Void)?
    var updateQuantity: ((String) -> Void)?
    var loading: ((Bool) -> Void)?
    var saved: ((Bool) -> Void)?
    var hideSaveQuantityButton: ((Bool) -> Void)?
    var hideSavePriceButton: ((Bool) -> Void)?
    var goBack: (() -> Void)?
    
    
    // MARK: - DataSource
    var numberOfImages: Int { images.count }
    var numberOfSizes: Int { sizes.count }
    var numberOfColor: Int { colors.count }
    
    func imageFor(cell: ProductImageCollectionViewCell, at index: Int){
        cell.setProductImage(withURLString: images[index].src)
    }
    
    func sizeFor(cell: CircularCollectionViewCell, at index: Int){
        cell.setTitle(sizes[index])
    }
    
    func colorFor(_ cell: CircularCollectionViewCell, at index: Int){
        cell.setTitle(colors[index])
    }
    
    func didSelectSize(at index: Int){
        selectedSize = index
        updateCurrentVariant()
    }
    
    func didSelectColor(at index: Int) {
        selectedColor = index
        updateCurrentVariant()
    }
    
    func incrementQuantity() {
        currentQuantity += 1
    }
    
    func decrementQuantity() {
        currentQuantity -= 1
        if currentQuantity < 1 {
            currentQuantity = 1
            self.error?("You can't decrement quantity any more, Minimum quantity is 1. You can delete the size or color for this product")
        }
    }
    
    
    
    // MARK: - Functions
    func setProductID(_ id: Int) {
        self.productID = id
    }
    
    func fetchProduct() {
        loading?(true)
        AF.request(K.baseURL + "/products/\(productID).json", headers: K.APIHeader).responseDecodable(of: SingleProductResponse.self) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loading?(false)
            }
            switch response.result {
            case .success(let product):
                self.product = product.result
                self.filterFields()
                print(product.result.variants.count)
                DispatchQueue.main.async {
                    self.reload?()
                }

            case .failure(let error):
                print(error)
                self.error?(error.localizedDescription)
            }
        }
    }
    
    private func filterFields() {
        guard let product = product else { return }
        images = product.images
        if let sizes = product.options.first(where: { $0.name == "Size" })?.values {
            self.sizes = sizes
        }

        if let colors = product.options.first(where: { $0.name == "Color" })?.values {
            self.colors = colors
        }
        updateCurrentVariant()
    }
    
    
    private func updateCurrentVariant() {
        guard let product = product, !sizes.isEmpty, !colors.isEmpty else {
            currentVariant = product?.variants.first
            return
        }
        currentVariant = product.variants.first(where: { $0.title == "\(sizes[selectedSize]) / \(colors[selectedColor])" })
    }
    
    func deleteImage(at index: Int) {
        guard !images.isEmpty else {
            self.error?("No image to be deleted!")
            return
        }
        let urlString = K.baseURL + "/products/\(productID)/images/\(images[index].id).json"
        
        loading?(true)
        
        AF.request(urlString, method: .delete, headers: K.APIHeader).response { response in
            DispatchQueue.main.async {
                self.loading?(false)
            }
            switch response.result {
            case .success(let data):
                //print(String(data: data!, encoding: .utf8) ?? "")
                self.saved?(data != nil)
                self.fetchProduct()
                
            case .failure(let error):
                self.error?(error.localizedDescription)
            }
        }
    }
    
    func saveNewQuantity() {
        guard let currentVariant = currentVariant else { return }
        let url = K.baseURL + "/inventory_levels/set.json"
        
        
        let params = [
            "location_id": 72119550188,
            "inventory_item_id": currentVariant.inventoryID,
            "available": currentQuantity
            //            "available_adjustment": currentQuantity
        ]
        
        loading?(true)
        AF.request(url, method: .post, parameters: params, headers: K.APIHeader).response { response in
            DispatchQueue.main.async {
                self.loading?(false)
            }
            switch response.result {
            case .success(let data):
                print(String(data: data!, encoding: .utf8) ?? "")
                self.saved?(data != nil)
                
            case .failure(let error):
                self.error?(error.localizedDescription)
            }
        }
    }
    
    
    func priceDidChange(_ price: String?) {
        guard let currentVariant = currentVariant else { return }
        if let price = price {
            hideSavePriceButton?(price == currentVariant.price)
        }
    }
    
    func savePrice(_ price: String?) {
        guard let currentVariant = currentVariant, let price = price else { return }
        let url = K.baseURL + "/products/\(productID)/variants/\(currentVariant.id).json"
        loading?(true)
        AF.request(url, method: .put, parameters: ["variant": ["price": price]], headers: K.APIHeader).response { response in
            DispatchQueue.main.async {
                self.loading?(false)
            }
            switch response.result {
            case .success(let data):
                //print(String(data: data!, encoding: .utf8) ?? "")
                self.saved?(data != nil)
                self.fetchProduct()
                DispatchQueue.main.async {
                    self.hideSavePriceButton?(true)
                }

            case .failure(let error):
                self.error?(error.localizedDescription)
            }
        }
    }
    
    func deleteProduct() {
        guard let product = product else { return }
        let url = K.baseURL + "/products/\(product.id).json"
        loading?(true)
        AF.request(url, method: .delete, headers: K.APIHeader).response { response in
            DispatchQueue.main.async {
                self.loading?(false)
            }
            switch response.result {
            case .success(_):
                DispatchQueue.main.async {
                    self.goBack?()
                }
                
            case .failure(let error):
                self.error?(error.localizedDescription)
            }
        }
    }
    
    private func deleteVariants(_ variants: [Variant]) {
        guard let product = product else { return }
        if !variants.isEmpty {
            loading?(true)
        }
        for variantIndex in variants.indices {
            let url = K.baseURL + "/products/\(product.id)/variants/\(variants[variantIndex].id).json"
            AF.request(url, method: .delete, headers: K.APIHeader).response { response in
                DispatchQueue.main.async {
                    if variantIndex == variants.count - 1 {
                        self.loading?(false)
                    }q
                }
                switch response.result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.saved?(data != nil)
                    }

                    if variantIndex == variants.count - 1 {
                        self.fetchProduct()
                    }

                case .failure(let error):
                    self.error?(error.localizedDescription)
                }
            }
        }
    }
    
    func deleteSize(at index: Int) {
        guard let product = product else { return }
        let size = sizes[index]
        let variants = product.variants.filter({ $0.title.contains(size) })
        deleteVariants(variants)
    }
    
    
    func deleteColor(at index: Int) {
        guard let product = product else { return }
        let color = colors[index]
        let variants = product.variants.filter({ $0.title.contains(color) })
        deleteVariants(variants)
    }
}
