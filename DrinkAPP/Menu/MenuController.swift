//
//  MenuController.swift
//  DrinkAPP
//
//  Created by 塗詠順 on 2022/1/3.
//

import Foundation
import UIKit

class MenuController{
    
    static let shared = MenuController()
    
    let apiKey = "Bearer keyxuSQfoQq6dMTTb"
    let header = "Authorization"
    
    func fetchItems(getURL url: URL?, completion: @escaping (Result<[Records], Error>) -> Void) {
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: header)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let content = String(data: data, encoding: .utf8){
                print(content)
                do{
                    let decoder = JSONDecoder()
                    let drinkresponse = try decoder.decode(DrinkResponse.self, from: data)
                    completion(.success(drinkresponse.records))
                    print(drinkresponse)
                }catch{
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchImage(getUrl url: URL?, completion: @escaping (UIImage?) -> Void) {
        if let url = url {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let image = UIImage(data: data)
                    completion(image)
                }else{
                    completion(nil)
                }
            }.resume()
        }
    }
    
    
}
