//
//  OptionsController.swift
//  DrinkAPP
//
//  Created by 塗詠順 on 2022/2/6.
//

import Foundation
import UIKit

class OptionsController {
    
    static let shared = OptionsController()
    
    func createDrinkList(getURL url: URL?, optionsResult: CreateRecords, completion: @escaping (Result<[CreateRecords],Error>) -> Void) {
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(MenuController.shared.apiKey, forHTTPHeaderField: MenuController.shared.header)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let encoder = JSONEncoder()
            let data = try? encoder.encode(optionsResult)
            request.httpBody = data
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data, let content = String(data: data, encoding: .utf8) {
                    print(content)
                    let decoder = JSONDecoder()
                    do {
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
