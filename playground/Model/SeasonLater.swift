//
//  SeasonLater.swift
//  playground
//
//  Created by Cesar Guasca on 15/12/21.
//

import Foundation
struct SeasonLater: Codable {
    let requestHash: String
    let requestCached: Bool
    let requestCacheExpiry: Int
    let seasonName: String
    let anime: [Anime]

    enum CodingKeys: String, CodingKey {
        case requestHash = "request_hash"
        case requestCached = "request_cached"
        case requestCacheExpiry = "request_cache_expiry"
        case seasonName = "season_name"
        case anime
    }
}
