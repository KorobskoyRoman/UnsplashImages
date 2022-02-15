//
//  ImageData.swift
//  UnsplashImages
//
//  Created by Roman Korobskoy on 08.02.2022.
//

import Foundation

class ImageData: Codable {
    static func == (lhs: ImageData, rhs: ImageData) -> Bool {
        lhs.results == rhs.results
    }
    
    let results: [Result]
}

class Result: NSObject, Codable {
    
    let urls: [Urls.RawValue:String]
    
    enum Urls: String, Hashable {
        case raw
        case full
        case regular
        case small
        case thumb
    }
    
    static func == (lhs: Result, rhs: Result) -> Bool {
        return lhs.urls == rhs.urls
    }
    
//    override var hash: Int {
//        hasher.combine(urls)
//    }
}
