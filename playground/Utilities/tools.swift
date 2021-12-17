//
//  tools.swift
//  playground
//
//  Created by Cesar Guasca on 15/12/21.
//

import Foundation
class Tools {
    static let shared: Tools = Tools()
    var settings = Dictionary<String, AnyObject>()
    func readSettingsPlist() -> Dictionary<String, AnyObject> {
        let path = Bundle.main.path(forResource: "settings", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!) as? Dictionary<String, AnyObject>
        return dict!
    }
    
    func getUrlRequest() -> String {
        self.settings = readSettingsPlist()
        return self.settings["Url"] as! String
    }
}
