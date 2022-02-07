//
//  ImageModel.swift
//  UnsplashImages
//
//  Created by Roman Korobskoy on 07.02.2022.
//

import Foundation
import UIKit

struct ImageModel: Hashable {
    var images: [String]
    
    init?(imageData: ImageData) {
        var tempArray: [String] = []
        imageData.results.forEach { image in
            tempArray.append(image.urls.full!)
        }
        self.images = tempArray
    }
}
