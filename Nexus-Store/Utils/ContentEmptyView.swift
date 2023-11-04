//
//  ContentEmptyView.swift
//  Nexus-Store
//
//  Created by Khater on 21/10/2023.
//

import UIKit



class ContentEmptyView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.numberOfLines = 0
        label.text = "No Content!"
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "empty_1")
        return imageView
    }()
    
    
    init() {
        super.init(frame: .zero)
        setupAppearance()
        setupComponents()
        print("ContentEmptyView init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAppearance() {
        self.backgroundColor = UIColor(named: "Background")
        self.isHidden = true
    }
    
    private func setupComponents() {
        addSubview(titleLabel)
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -36)
        ])
    }
    
    func addTo(_ superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        superView.insertSubview(self, at: superView.subviews.count)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
    }
    
    func setTitle(_ text: String){
        titleLabel.text = text
    }
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    
    deinit {
        print("ContentEmptyView deinit")
    }
}

