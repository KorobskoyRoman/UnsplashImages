//
//  NetworkManager.swift
//  UnsplashImages
//
//  Created by Roman Korobskoy on 08.02.2022.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchPhotos(searchText: String, completion: @escaping (ImageModel) -> Void) {
        let apiKey = "Tb2OdOBrRDkyMDye7PNozlFWSkXrCh_3DWmrU40EI2E"
        let urlString = "https://api.unsplash.com/search/photos/?page=1&per_page=10&client_id=\(apiKey)&query=\(searchText)"
        
        guard let urlString = URL(string: urlString) else { return }
        
        var request = URLRequest(url: urlString, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlString) { data, response, error in
            guard let data = data else {
                return
            }
            if let imageModel = self.parseJSON(withData: data) {
                print("data from parsing: \(imageModel)")
                completion(imageModel)
            }
        }
        task.resume()
    }
    
    func parseJSON(withData data: Data) -> ImageModel? {
        let decoder = JSONDecoder()
        do {
            let imageData = try decoder.decode(ImageData.self, from: data)
            guard let imageModel = ImageModel(imageData: imageData) else { return nil }
            print("данные из парсинга: \(imageData)")
            return imageModel
        } catch let error {
            print("error: \(error)")
        }
        return nil
    }
}
