//
//  Alert.swift
//  UnsplashImages
//
//  Created by Roman Korobskoy on 27.02.2022.
//

import UIKit

class Alert {
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .none
        return view
    }()
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .cyan
        return imageView
    }()
    
    private var myTargetView: UIView?
    
    func showAlert(title: String, message: String, viewController: UIViewController) {
        
        guard let targetView = viewController.view else { return }
        myTargetView = targetView
        
        alertView.frame = CGRect(x: 40, y: -200, width: targetView.frame.width - 60, height: 250)
        targetView.addSubview(alertView)
        backgroundImage.frame = CGRect(x: 0, y: 0, width: alertView.frame.width, height: alertView.frame.height)
        alertView.clipsToBounds = true
        alertView.layer.cornerRadius = 10
        alertView.addSubview(backgroundImage)
        alertView.layer.borderWidth = 5
        alertView.layer.borderColor = UIColor.mainWhite().cgColor
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 5, width: alertView.frame.width, height: 44))
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textColor = .systemRed
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "American Typewriter Bold", size: 30)
        alertView.addSubview(titleLabel)
        
        let messageLabel = UILabel(frame: CGRect(x: 30, y: 0, width: alertView.frame.width - 60, height: alertView.frame.height - 10))
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont(name: "American Typewriter Bold", size: 16)
        alertView.addSubview(messageLabel)
        
        let okAction = UIButton(frame: CGRect(x: 140, y: alertView.frame.height - 50, width: alertView.frame.width - 280, height: 40))
        okAction.applyGradients(cornerRadius: 10)
        okAction.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 20)
        okAction.setTitle("Got it!", for: .normal)
        okAction.titleLabel?.textColor = .mainWhite()
        okAction.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        alertView.addSubview(okAction)
        
        UIView.animate(withDuration: 0.3) {
            self.alertView.center = targetView.center
        }
    }
    
    @objc func dismissAlert() {
        guard let targetView = myTargetView else { return }
        UIView.animate(withDuration: 0.3) {
            self.alertView.frame = CGRect(x: 40, y: targetView.frame.height, width: targetView.frame.width - 80, height: 300)
        } completion: { done in
            if done {
                self.alertView.removeFromSuperview()
            }
        }
    }
}
