//
//  UIView + Extension.swift
//  UnsplashImages
//
//  Created by Roman Korobskoy on 25.02.2022.
//

import UIKit

extension UIView {
    
    func applyGradients(cornerRadius: CGFloat) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientView = GradientView(from: .leading, to: .trailing, startColor: #colorLiteral(red: 1, green: 0.1719351113, blue: 0.4505646229, alpha: 1), endColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = cornerRadius
            
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}

extension UIView {
    static let loadingViewTag = 1938123987
    func showLoading(style: UIActivityIndicatorView.Style = .large, color: UIColor? = nil) {
        DispatchQueue.main.async {
            var loading = self.viewWithTag(UIImageView.loadingViewTag) as? UIActivityIndicatorView
            if loading == nil {
                loading = UIActivityIndicatorView(style: style)
            }
            
            loading?.translatesAutoresizingMaskIntoConstraints = false
            loading!.startAnimating()
            loading!.hidesWhenStopped = true
            loading?.tag = UIView.loadingViewTag
            self.addSubview(loading!)
            loading?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            loading?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            
            if let color = color {
                loading?.color = color
            }
        }
    }

    func stopLoading() {
        DispatchQueue.main.async {
            let loading = self.viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView
            loading?.stopAnimating()
            loading?.removeFromSuperview()
        }
    }
}
