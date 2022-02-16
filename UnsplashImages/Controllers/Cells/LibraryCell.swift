//
//  LibraryCell.swift
//  UnsplashImages
//
//  Created by Roman Korobskoy on 16.02.2022.
//

import UIKit

class LibraryCell: UICollectionViewCell {
    
    static let reuseId = "LibraryCell"
    let imageView = UIImageView()
    let containterView = UIView()
    
    var photo: Result! {
        didSet {
            let imageUrl = photo.urls["regular"]
            guard let photoUrl = imageUrl, let url = URL(string: photoUrl) else { return }
            imageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func layoutSubviews() { //округляем всю ячейку
        super.layoutSubviews()
        self.containterView.layer.cornerRadius = 4
        self.containterView.clipsToBounds = true
        self.layer.cornerRadius = 4
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConstraints()
        
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemRed
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        addSubview(containterView)
        containterView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            containterView.topAnchor.constraint(equalTo: self.topAnchor),
            containterView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containterView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containterView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containterView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containterView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containterView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containterView.bottomAnchor)
        ])
    }
}
