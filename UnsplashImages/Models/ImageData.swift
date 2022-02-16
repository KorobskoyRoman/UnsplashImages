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

struct Result: Codable, Hashable {
    
    let uuid = UUID()
    let urls: [Urls.RawValue:String]
    
    private enum CodingKeys : String, CodingKey { case urls }
    
    enum Urls: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
    
    static func == (lhs: Result, rhs: Result) -> Bool {
        lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
