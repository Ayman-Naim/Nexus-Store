//
//  UIViewController+Extension.swift
//  Nexus-Store
//
//  Created by Khater on 21/10/2023.
//

import UIKit
import Lottie


extension UIViewController {
    

    var isContentEmptyViewHidden: Bool {
        set {
            // Check if there is subview that is of type ContentEmptyView Class
            if let index = view.subviews.firstIndex(where: { $0 is ContentEmptyView }) {
                // if is found then set isHidden property with isContentEmptyViewHidden new value
                view.subviews[index].isHidden = newValue
            } else {
                // Not found any subView of type ContentEmptyView Class then create new ContentEmptyView
                createContentEmptyView(withTitle: nil, image: nil)
            }
            // NOTE: ContentEmptyView will created only when this propert is setted or when setting Title or image
        }
        get {
            if let index = view.subviews.firstIndex(where: { $0 is ContentEmptyView }) {
                return view.subviews[index].isHidden
            } else {
                return true
            }
        }
    }
    
    func setContentEmptyTitle(_ title: String) {
        if let contentEmptyView = view.subviews.first(where: { $0 is ContentEmptyView }) as? ContentEmptyView {
            contentEmptyView.setTitle(title)
        } else {
            createContentEmptyView(withTitle: title, image: nil)
        }
    }
    
    func setContentEmptyImage(_ image: UIImage?){
        if let contentEmptyView = view.subviews.first(where: { $0 is ContentEmptyView }) as? ContentEmptyView {
            contentEmptyView.setImage(image)
        } else {
            createContentEmptyView(withTitle: nil, image: image)
        }
    }
    
    private func createContentEmptyView(withTitle title: String?, image: UIImage?) {
        // Create ContentEmptyView
        let contentEmptyView = ContentEmptyView()
        // Add contentEmptyView as subView in UIViewController view
        contentEmptyView.addTo(self.view)
        
        // Set Title if not nil -> There is a default title in ContentEmptyView
        if let title = title {
            contentEmptyView.setTitle(title)
        }
        
        // Set Image if not nil -> There is a default image in ContentEmptyView
        if let image = image {
            contentEmptyView.setImage(image)
        }
    }
    
    
    // MARK: - CustomLoadingIndicator
    var isLoadingIndicatorAnimating: Bool {
        set {
            if newValue {
                let customLoadingIndicator = CustomLoadingIndicator(customAnimation: "loading_4")
                customLoadingIndicator.addLoadingIndicator(to: self.view)
            } else {
                view.subviews.first(where: { $0 is CustomLoadingIndicator })?.removeFromSuperview()
            }
        }
        get { view.subviews.contains(where: { $0 is CustomLoadingIndicator }) }
    }
    
    
    //MARK: -  ADding Logo to Navigation Bar
    func addLogoToNavigationBarItem(logoImage:String) {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: logoImage)
        let contentView = UIView()
        self.navigationItem.titleView = contentView
        self.navigationItem.titleView?.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    
    

   
    
}

