//
//  NetworkManager.swift
//  UnsplashImages
//
//  Created by Roman Korobskoy on 08.02.2022.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchPhotos(searchText: String, completion: @escaping (ImageData) -> Void) {
        let apiKey = "Tb2OdOBrRDkyMDye7PNozlFWSkXrCh_3DWmrU40EI2E"
        let urlString = "https://api.unsplash.com/search/photos/?page=1&per_page=10&client_id=\(apiKey)&query=\(searchText)"
        
        guard let urlString = URL(string: urlString) else { return }
        
        var request = URLRequest(url: urlString, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlString) { data, response, error in
            guard let data = data else {
                return
            }
            if let imageModel = self.parseJSON(type: ImageData.self, data: data) {
                print("data from parsing: \(imageModel)")
                completion(imageModel)
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
            print("parsing json data: \(imageData)")
            return imageData
        } catch let jsonError {
            print("error: \(jsonError)")
            return nil
        }
    }
}
