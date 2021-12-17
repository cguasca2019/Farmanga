//
//  Demographic.swift
//  playground
//
//  Created by Cesar Guasca on 17/12/21.
//

import Foundation
// MARK: - Demographic
struct Demographic: Codable {
    let malID: Int
    let type: TypeEnum
    let name: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case type, name, url
    }
}

enum TypeEnum: String, Codable {
    case anime = "anime"
    case manga = "manga"
}
