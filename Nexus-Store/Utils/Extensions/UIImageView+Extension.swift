//
//  UIImageView+Extension.swift
//  Nexus-Store
//
//  Created by Khater on 19/10/2023.
//

import UIKit
import Kingfisher


extension UIImageView {
    func setImage(withURLString urlString: String) {
        self.kf.setImage(with: URL(string: urlString), placeholder: UIImage(named: "App-logo")) { [weak self] result in
            switch result {
            case .success(_):
                print("")
            case .failure(_):
                self?.backgroundColor = .label
                self?.tintColor = .systemBackground
                self?.image = UIImage(named: "App-logo")
            }
        }
    }
}
