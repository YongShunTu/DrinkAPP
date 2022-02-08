//
//  ListController.swift
//  DrinkAPP
//
//  Created by 塗詠順 on 2022/1/8.
//


import Foundation
import UIKit

class ListController {
    
    static let shared = ListController()
   
    func fetchImage(getURL url: URL?, completion: @escaping (UIImage?) -> Void) {
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
    
    func fetchList(getURL url: URL?, completion: @escaping (Result<[CreateRecords],Error>) -> Void) {
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(MenuController.shared.apiKey, forHTTPHeaderField: MenuController.shared.header)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do{
                        let list = try decoder.decode(CreateMenuList.self, from: data)
                        completion(.success(list.records))
                    }catch{
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
    
}
