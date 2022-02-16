//
//  NetworkManager.swift
//  UnsplashImages
//
//  Created by Roman Korobskoy on 08.02.2022.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchPhotos(page: Int = 1, searchText: String, completion: @escaping (ImageData) -> Void) {
        let apiKey = "Tb2OdOBrRDkyMDye7PNozlFWSkXrCh_3DWmrU40EI2E"
        let page = page
        let urlString = "https://api.unsplash.com/search/photos/?page=\(page)&per_page=10&client_id=\(apiKey)&query=\(searchText)"
        
        guard let urlString = URL(string: urlString) else { return }
        
        var request = URLRequest(url: urlString, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlString) { data, response, error in
            guard let data = data else {
                return
            }
            if let imageModel = self.parseJSON(type: ImageData.self, data: data) {
//                print("data from parsing: \(imageModel)")
                completion(imageModel)
            }
        }
        task.resume()
    }
    
    func fetchPopular(page: Int,completion: @escaping ([Result]) -> Void) {
        let apiKey = "Tb2OdOBrRDkyMDye7PNozlFWSkXrCh_3DWmrU40EI2E"
        let urlString = "https://api.unsplash.com/photos?page=\(page)&client_id=\(apiKey)"
        
        guard let urlString = URL(string: urlString) else { return }
        
        var request = URLRequest(url: urlString, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlString) { data, response, error in
            guard let data = data else {
                return
            }
            if let popularData = self.parseJSON(type: [Result].self, data: data) {
//                print("popular images: \(popularData)")
                completion(popularData)
            }
        }
        task.resume()
    }
    
    func parseJSON<T: Decodable>(type: T.Type, data: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = data else {
            return nil
        }
        do {
            let imageData = try decoder.decode(T.self, from: data)
//            print("parsing json data: \(imageData)")
            return imageData
        } catch let jsonError {
            print("error pasring json: \(jsonError)")
            return nil
        }
    }
}
