//
//  RealmManager.swift
//  UnsplashImages
//
//  Created by Roman Korobskoy on 21.02.2022.
//

import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    
    private init() {}
    
    let localRealm = try! Realm()
    
    func saveImageModel(photo: RealmImageModel) {
        do {
            try localRealm.write({
                localRealm.add(photo)
            })
        } catch {
            print(error)
        }
    }
}

extension Results {
  func toArray() -> [Element] {
    return compactMap {
        $0
    }
  }
}
