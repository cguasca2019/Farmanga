//
//  Anime.swift
//  playground
//
//  Created by Cesar Guasca on 15/12/21.
//

import Foundation
struct Anime: Codable {
    let malID: Int
    let url: String
    let title: String
    let imageURL: String
    let synopsis: String?
    let type: String?
    let episodes: Int?
    let members: Int
    let source: String?
    let score: Double?
    let scoreBy: Int?
    let r18, kids, continuing, airing: Bool?
    let genres: [Demographic]?

    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case url, title
        case imageURL = "image_url"
        case scoreBy = "scored_by"
        case synopsis, type
        case episodes, members, genres
        case source, score, r18, kids, continuing, airing
    }
}
