//
//  SearchAnimes.swift
//  playground
//
//  Created by Cesar Guasca on 17/12/21.
//

import Foundation
// MARK: - SearchAnimes
struct SearchAnimes: Codable {
    let requestHash: String?
    let requestCached: Bool?
    let requestCacheExpiry: Int?
    let results: [Anime]?
    let status: Int?

    enum CodingKeys: String, CodingKey {
        case requestHash = "request_hash"
        case requestCached = "request_cached"
        case requestCacheExpiry = "request_cache_expiry"
        case results, status
    }
}
