//
//  DetailVM.swift
//  playground
//
//  Created by Cesar Guasca on 16/12/21.
//

import Foundation

class DetailVM: ListenerGetDetail {
    var api: Api = Api()
    var refreshData = { () -> () in }
    
    var detailAnimes: Anime? {
        didSet {
            refreshData()
        }
    }
    
    func retrivePopularList(animeIdView: Int) {
        self.api.listenerGetDetail = self
        self.api.getDetail(animeId: animeIdView)
    }
    
    func successGetDetail(_ response: Anime) {
        detailAnimes = response
    }
    
    func failureGetDetail(_ loginError: String) {
        print(loginError)
    }
}
