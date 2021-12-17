//
//  ApiProtocols.swift
//  playground
//
//  Created by Cesar Guasca on 15/12/21.
//

import Foundation
protocol ListenerGetPopular {
    func successGetPopular(_ response : TopAnimes)
    func failureGetPopular(_ loginError : String)
}

protocol ListenerGetSeasonLater {
    func successGetSeasonLater(_ response : SeasonLater)
    func failureGetSeasonLater(_ loginError : String)
}

protocol ListenerGetDetail {
    func successGetDetail(_ response : Anime)
    func failureGetDetail(_ loginError : String)
}


protocol ListenerSearch {
    func successSearch(_ response : SearchAnimes)
    func failureSearch(_ loginError : String)
}
