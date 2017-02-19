//
//  RestApiManager.swift
//  Challenge
//
//  Created by Conrado Mateu Gisbert on 19/02/17.
//  Copyright © 2017 conradomateu. All rights reserved.
//

import Foundation
import UIKit
class RestApiManager: NSObject {
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    var superHeroes = [SuperHero]()
    
    let tableView: UITableView
    let baseURL = "http://comicvine.gamespot.com/api/characters"
    let format = "json"
    
    private func getURL() -> URL {
        let apiKey = valueForAPIKey(named: "API_KEY")
        let url = NSURL(string: baseURL + "?api_key=" + apiKey + "&format=" + format)! as URL
        return url
    }
    
    func getDataFrom(url: URL){

        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = NSURLRequest(url: url)
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                    if let results = json["results"] as? [[String:Any]] {
                        results.forEach{
                            if let sh = SuperHero(json: $0){
                                self.superHeroes.append(sh)
                            }
                        }
                        self.reloadTableView()
                    }
                    
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    func getSuperHeroes() -> [SuperHero] {
        return self.superHeroes
    }
    
    func initialize() {
        getDataFrom(url: getURL())
    }
    
    func reloadTableView() {
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    func valueForAPIKey(named keyname:String) -> String {
        let filePath = Bundle.main.path(forResource: "ApiKey", ofType: "plist")
        let plist = NSDictionary(contentsOfFile:filePath!)
        let value = plist?.object(forKey: keyname) as! String
        return value
    }
}
