//
//  ResponseModels.swift
//  DrinkAPP
//
//  Created by 塗詠順 on 2022/1/3.
//

import Foundation

struct DrinkResponse: Decodable{
    let records: [Records]
}

struct Records: Decodable{
    let id: String
    let fields: Fields
}

struct Fields: Decodable{
    let name: String
    let content: String
    let detail: String
    let image: [ImageURL]?
    let ice: Array<String>?
    let sweet: Array<String>?
    let size: Array<String>?
    let price: Int
    
}

struct ImageURL: Decodable{
    let url: URL
}




