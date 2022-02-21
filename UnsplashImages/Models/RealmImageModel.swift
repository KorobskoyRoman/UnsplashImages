//
//  RealmImageModel.swift
//  UnsplashImages
//
//  Created by Roman Korobskoy on 21.02.2022.
//

import RealmSwift

class RealmImageModel: Object {
    @Persisted var urlImage: String = ""
}
