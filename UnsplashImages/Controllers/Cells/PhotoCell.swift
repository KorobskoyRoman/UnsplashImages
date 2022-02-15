//
//  PhotoCell.swift
//  UnsplashImages
//
//  Created by Roman Korobskoy on 07.02.2022.
//

import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
    
    static var reuseId = "reuseId"
    let imagePhoto = UIImageView()
    let containterView = UIView()
    
    var likeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "heart.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .apRed()
        return button
    }()
    private var isLiked: Bool = false
    
    var photo: Result! {
        didSet {
            let imageUrl = photo.urls["regular"]
            guard let photoUrl = imageUrl, let url = URL(string: photoUrl) else { return }
            imagePhoto.sd_setImage(with: url, completed: nil)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imagePhoto.image = nil
    }
    
    override func layoutSubviews() { //округляем всю ячейку
        super.layoutSubviews()
        self.containterView.layer.cornerRadius = 10
        self.layer.cornerRadius = 10
        self.containterView.clipsToBounds = true
        self.imagePhoto.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setConstraints()
        likeButton.addTarget(self, action: #selector(likeButtonPressed(_:)), for: .touchUpInside)
        
        self.layer.shadowColor = UIColor.mainBlack().cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func likeButtonPressed(_ sender: UIButton!) {
        let defaults = UserDefaults.standard
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: Result.self, requiringSecureCoding: false) {
            print("success")
            defaults.set(savedData, forKey: "photos")
        }
    }

    private func setConstraints() {
        containterView.translatesAutoresizingMaskIntoConstraints = false
        imagePhoto.translatesAutoresizingMaskIntoConstraints = false
        imagePhoto.backgroundColor = .systemRed
        imagePhoto.clipsToBounds = true
        imagePhoto.contentMode = .scaleAspectFill
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containterView)
        containterView.addSubview(imagePhoto)
        self.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            containterView.topAnchor.constraint(equalTo: self.topAnchor),
            containterView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containterView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containterView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imagePhoto.topAnchor.constraint(equalTo: containterView.topAnchor),
            imagePhoto.leadingAnchor.constraint(equalTo: containterView.leadingAnchor),
            imagePhoto.trailingAnchor.constraint(equalTo: containterView.trailingAnchor),
            imagePhoto.bottomAnchor.constraint(equalTo: containterView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: imagePhoto.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imagePhoto.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 50),
            likeButton.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
}
