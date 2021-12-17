//
//  SearchVM.swift
//  playground
//
//  Created by Cesar Guasca on 16/12/21.
//

import Foundation

class SearchVM: ListenerSearch {
    var api: Api = Api()
    var refreshData = { () -> () in }
    
    var detailSearch: SearchAnimes? {
        didSet {
            refreshData()
        }
    }
    
    func search(query: String) {
        self.api.listenerSearch = self
        self.api.search(query: query)
    }
    
    func successSearch(_ response: SearchAnimes) {
        detailSearch = response
    }
    
    func failureSearch(_ loginError: String) {
        print(loginError)
    }
}
