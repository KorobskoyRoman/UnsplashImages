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
    
    private let checkImage: UIImageView = {
        let image = UIImage(systemName: "checkmark.circle.fill")
        let imageView = UIImageView(image: image)
        imageView.alpha = 0
        return imageView
    }()
    private var isLiked: Bool = false
    
    var photo: Result! {
        didSet {
            let imageUrl = photo.urls["regular"]
            guard let photoUrl = imageUrl, let url = URL(string: photoUrl) else { return }
            imagePhoto.sd_setImage(with: url, completed: nil)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelected()
        }
    }
    
    private func updateSelected() {
        imagePhoto.alpha = isSelected ? 0.7 : 1
        checkImage.alpha = isSelected ? 1 : 0
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
        updateSelected()
        
        self.layer.shadowColor = UIColor.mainBlack().cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraints() {
        containterView.translatesAutoresizingMaskIntoConstraints = false
        imagePhoto.translatesAutoresizingMaskIntoConstraints = false
        imagePhoto.backgroundColor = .systemRed
        imagePhoto.clipsToBounds = true
        imagePhoto.contentMode = .scaleAspectFill
        checkImage.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containterView)
        containterView.addSubview(imagePhoto)
        self.addSubview(checkImage)
        
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
            checkImage.topAnchor.constraint(equalTo: imagePhoto.topAnchor),
            checkImage.trailingAnchor.constraint(equalTo: imagePhoto.trailingAnchor),
            checkImage.widthAnchor.constraint(equalToConstant: 50),
            checkImage.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
}
