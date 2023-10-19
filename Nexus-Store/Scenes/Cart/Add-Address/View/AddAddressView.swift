//
//  AddAddressView.swift
//  Nexus-Store
//
//  Created by Khater on 19/10/2023.
//

import UIKit


class AddAddressView: UIView {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Name"
        textField.returnKeyType = .next
        return textField
    }()
    private let cityTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "City"
        textField.returnKeyType = .next
        textField.textContentType = .addressCity
        return textField
    }()
    
    private let addressTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Address"
        textField.returnKeyType = .done
        textField.textContentType = .streetAddressLine1
        return textField
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "Title")
        button.setTitle("Add", for: .normal)
        button.tintColor = .systemBackground
        button.layer.cornerRadius = 16
        return button
    }()
    
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(named: "Background")
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupSubViews() {
        setupScrollView()
        setupContainerView()
        setupNameTextField()
        setupCityTextField()
        setupAddressTextField()
        setupAddButton()
    }
    
    private func setupScrollView() {
        self.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupContainerView() {
        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func setupNameTextField() {
        containerView.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            nameTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
            nameTextField.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    private func setupCityTextField() {
        containerView.addSubview(cityTextField)
        NSLayoutConstraint.activate([
            cityTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            cityTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            cityTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
            cityTextField.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    private func setupAddressTextField() {
        containerView.addSubview(addressTextField)
        NSLayoutConstraint.activate([
            addressTextField.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 16),
            addressTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            addressTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
            addressTextField.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    private func setupAddButton() {
        containerView.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 64),
            addButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            addButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
            addButton.heightAnchor.constraint(equalToConstant: 55),
            addButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        ])
    }
}
