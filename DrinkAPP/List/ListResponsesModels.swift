//
//  ListResponsesModels.swift
//  DrinkAPP
//
//  Created by 塗詠順 on 2022/1/8.
//

import Foundation

struct CreateMenuList: Codable {
    let records: [CreateRecords]
}
        
struct CreateRecords: Codable {
    let id: String?
    let fields: CreateFields
}

struct CreateFields: Codable {
    let name: String
    let ice: String
    let sweet: String
    let size: String
    let price: Int
    let cups: Int
    let image: [CreateImageURL]?
}

struct CreateImageURL: Codable {
    let url: URL?
}

