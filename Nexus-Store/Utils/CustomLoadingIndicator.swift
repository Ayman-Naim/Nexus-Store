//
//  CustomLoadingIndicator.swift
//  Nexus-Store
//
//  Created by Khater on 21/10/2023.
//

import UIKit
import Lottie


class CustomLoadingIndicator: UIView {
    
    private let animationView: LottieAnimationView
    
    init(customAnimation name: String){
        self.animationView = LottieAnimationView(name: name)
        super.init(frame: .zero)
        setupAnimationView()
        print("CustomLoadingIndicator init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAnimationView() {
        animationView.shadowOpacity = 0.1
        animationView.tintColor = .label
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.play()
    }
    
    private func setupLottieAnimationViewConstraints() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: widthAnchor),
            animationView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    func addLoadingIndicator(to view: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(self, at: view.subviews.count)
        setupLottieAnimationViewConstraints()
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 12),
            centerYAnchor.constraint(equalTo: view.centerYAnchor),
            widthAnchor.constraint(equalToConstant: 150),
            heightAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    deinit {
        print("CustomLoadingIndicator deinit")
    }
}
