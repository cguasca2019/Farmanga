//
//  Api.swift
//  playground
//
//  Created by Cesar Guasca on 15/12/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import Network

open class Api {
    let tools = Tools.shared
    let headers: HTTPHeaders = [
        .acceptEncoding("UTF-8"),
        .contentType("application/json"),
        .accept("application/json")
    ]
    
    var listenerGetPopularAnimes: ListenerGetPopular?
    var listenerGetSeasonLater: ListenerGetSeasonLater?
    var listenerGetDetail: ListenerGetDetail?
    var listenerSearch: ListenerSearch?
    
    func getPopularAnimes(){
        // Filtro por TOP + Popularidad
        let url = URL(string: tools.getUrlRequest() + "top/anime/1/bypopularity")
        print("URL METHOD", url!)
        
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.headers = headers
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    self.listenerGetPopularAnimes?.failureGetPopular("json GETPOPULARANIMES ERROR \(error)")
                    return
                }
                guard let data = data else {return}
                do{
                    let resp = try JSONDecoder().decode(TopAnimes.self, from: data)
                    self.listenerGetPopularAnimes?.successGetPopular(resp)
                }catch let jsonErr {
                    self.listenerGetPopularAnimes?.failureGetPopular("json GETPOPULARANIMES ERROR SERIALIZE - ERR: \(jsonErr)")
                }
        }
        task.resume()
    }
    
    func getSeasonLater(){
        // Filtro Season Later
        let url = URL(string: tools.getUrlRequest() + "season/later")
        print("URL METHOD", url!)
        
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.headers = headers
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    self.listenerGetSeasonLater?.failureGetSeasonLater("json GETSEASONLATER ERROR \(error)")
                    return
                }
                guard let data = data else {return}
                do{
                    let resp = try JSONDecoder().decode(SeasonLater.self, from: data)
                    self.listenerGetSeasonLater?.successGetSeasonLater(resp)
                }catch let jsonErr {
                    self.listenerGetSeasonLater?.failureGetSeasonLater("json GETSEASONLATER ERROR SERIALIZE - ERR: \(jsonErr)")
                }
        }
        task.resume()
    }
    
    func getDetail(animeId: Int){
        // Obtiene los detalles
        let url = URL(string: tools.getUrlRequest() + "anime/\(animeId)")
        print("URL METHOD", url!)
        
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.headers = headers
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    self.listenerGetDetail?.failureGetDetail("json GETDETAIL ERROR \(error)")
                    return
                }
                guard let data = data else {return}
                do{
                    let resp = try JSONDecoder().decode(Anime.self, from: data)
                    self.listenerGetDetail?.successGetDetail(resp)
                }catch let jsonErr {
                    self.listenerGetDetail?.failureGetDetail("json GETDETAIL ERROR SERIALIZE - ERR: \(jsonErr)")
                }
        }
        task.resume()
    }
    
    func search(query: String){
        // Filtro por Query sin más filtros
        let url = URL(string: tools.getUrlRequest() + "search/anime?q=\(query)&page=1")
        print("URL METHOD", url!)
        
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.headers = headers
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    self.listenerSearch?.failureSearch("json SEARCH ERROR \(error)")
                    return
                }
                guard let data = data else {return}
                do{
                    let resp = try JSONDecoder().decode(SearchAnimes.self, from: data)
                    self.listenerSearch?.successSearch(resp)
                }catch let jsonErr {
                    self.listenerSearch?.failureSearch("json SEARCH ERROR SERIALIZE - ERR: \(jsonErr)")
                }
        }
        task.resume()
    }
}
