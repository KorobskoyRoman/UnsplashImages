//
//  ImageData.swift
//  UnsplashImages
//
//  Created by Roman Korobskoy on 08.02.2022.
//

import Foundation

struct ImageData: Codable {
    let results: [Result]
}

struct Result: Codable {
    let urls: Urls
}

struct Urls: Codable {
    let full: String?
}
