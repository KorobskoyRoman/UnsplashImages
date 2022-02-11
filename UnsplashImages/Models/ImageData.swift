//
//  ImageData.swift
//  UnsplashImages
//
//  Created by Roman Korobskoy on 08.02.2022.
//

import Foundation

struct ImageData: Codable {
    let total: Int
    let results: [Result]
}

struct Result: Codable, Hashable {
    
    let urls: [Urls.RawValue:String]
    
    enum Urls: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
    
    static func == (lhs: Result, rhs: Result) -> Bool {
        lhs.urls == rhs.urls
    }
}
