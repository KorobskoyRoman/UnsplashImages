//
//  DetailsViewConroller.swift
//  UnsplashImages
//
//  Created by Roman Korobskoy on 17.02.2022.
//

import UIKit
import SDWebImage

class DetailsViewConroller: UIViewController {
    let imageView = UIImageView()
    let containerView = UIView()
    
    var photo: Result! {
        didSet {
            let imageUrl = photo.urls["raw"] ?? photo.urls["regular"]
            guard let photoUrl = imageUrl, let url = URL(string: photoUrl) else { return }
            imageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    var photoFromLibrary: RealmImageModel! {
        didSet {
            let imageUrl = photoFromLibrary.urlImage
            let url = URL(string: imageUrl)
            imageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInteraction()
        setConstraints()
    }
    
    private func setupUserInteraction() {
        imageView.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressedImage(sender:)))
        imageView.addGestureRecognizer(longPress)
    }
    
    @objc func longPressedImage(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            showAlert(title: "Save photo?", message: "Want to save photo?")
        }
    }
    
    @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            print("error save photo")
        } else {
            print("saved success")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let saveButton = UIAlertAction(title: "Save", style: .default) { photo in
            UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, #selector(self.saveCompleted), nil)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
    }
    
    private func setConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemRed
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        view.addSubview(containerView)
        containerView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}
