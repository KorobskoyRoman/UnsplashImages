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
    var imagePhoto = UIImageView()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setConstraints()
        
        self.layer.shadowColor = #colorLiteral(red: 0.7877369523, green: 0.7877556682, blue: 0.7877456546, alpha: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraints() {
        imagePhoto.translatesAutoresizingMaskIntoConstraints = false
        imagePhoto.backgroundColor = .systemRed
        imagePhoto.clipsToBounds = true
        imagePhoto.contentMode = .scaleAspectFill
        
        addSubview(imagePhoto)
        
        NSLayoutConstraint.activate([
            imagePhoto.topAnchor.constraint(equalTo: self.topAnchor),
            imagePhoto.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imagePhoto.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imagePhoto.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
