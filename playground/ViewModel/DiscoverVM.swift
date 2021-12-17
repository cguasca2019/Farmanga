//
//  DiscoverVM.swift
//  playground
//
//  Created by Cesar Guasca on 15/12/21.
//

import Foundation

class DiscoverVM: ListenerGetPopular, ListenerGetSeasonLater {
    var api: Api = Api()
    var refreshData = { () -> () in }
    var topAnimes: TopAnimes? {
        didSet {
            refreshData()
        }
    }
    
    var seasonLaterAnimes: SeasonLater? {
        didSet {
            refreshData()
        }
    }
    
    func retrivePopularList() {
        self.api.listenerGetPopularAnimes = self
        self.api.getPopularAnimes()
    }
    
    func retriveSeasonLater() {
        self.api.listenerGetSeasonLater = self
        self.api.getSeasonLater()
    }
    
    func successGetPopular(_ response: TopAnimes) {
        self.topAnimes = response
    }
    
    func failureGetPopular(_ loginError: String) {
        print(loginError)
    }
    
    func successGetSeasonLater(_ response: SeasonLater) {
        self.seasonLaterAnimes = response
    }
    
    func failureGetSeasonLater(_ loginError: String) {
        print(loginError)
    }
}

