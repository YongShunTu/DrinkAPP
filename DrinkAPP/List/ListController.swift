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
    var optionsResult: OptionsResult?
    
    func createDrinkList(getURL url: URL?, completion: @escaping (Result<[CreateRecords],Error>) -> Void) {
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(MenuController.shared.apiKey, forHTTPHeaderField: MenuController.shared.header)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let encoder = JSONEncoder()
            let list = CreateMenuList(records: [.init(id: nil, fields: .init(name: optionsResult!.content, ice: optionsResult!.ice, sweet: optionsResult!.sweet, size: optionsResult!.size, price: optionsResult!.price, cups: 1, image: [.init(url: optionsResult!.image)]))])
            let data = try? encoder.encode(list)
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
    
    func createDrinkImage(getURL url: URL?, completion: @escaping (UIImage?) -> Void) {
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
    

    
    func deleteList(getURL url: URL?) {
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue(MenuController.shared.apiKey, forHTTPHeaderField: MenuController.shared.header)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let response = response as? HTTPURLResponse {
                    print(response.statusCode)
                }
            }.resume()
        }
    }
    
    func updataList(getURL url: URL?, amount: Int, listSelect: CreateFields, complection: @escaping (Result<[CreateRecords],Error>) -> Void) {
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue(MenuController.shared.apiKey, forHTTPHeaderField: MenuController.shared.header)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let encoder = JSONEncoder()
//            let list = CreateRecords.init(id: nil, fields: .init(name: optionsResult!.content, ice: optionsResult!.ice, sweet: optionsResult!.sweet, size: optionsResult!.size, price: optionsResult!.price, cups: amount, image: [.init(url: optionsResult?.image)]))
            let list = CreateRecords.init(id: nil, fields: .init(name: listSelect.name, ice: listSelect.ice, sweet: listSelect.sweet, size: listSelect.size, price: listSelect.price, cups: amount, image: [.init(url: listSelect.image![0].url)]))
            let data = try? encoder.encode(list)
            request.httpBody = data
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data, let content = String(data: data, encoding: .utf8) {
                    let decoder = JSONDecoder()
                    do {
                        let list = try decoder.decode(CreateRecords.self, from: data)
                        complection(.success([list]))
                    }catch{
                        complection(.failure(error))
                    }
                }
            }.resume()
        }
    }

    
}
