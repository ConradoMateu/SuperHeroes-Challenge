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
    let apiKey = "cd2bdd5c415fea94bdbd7b463b5fa6a6914f6531"

    private func getURL() -> URL {
        let url = NSURL(string: baseURL + "?api_key=" + apiKey + "&format=" + format)! as URL
        return url
    }

    func getDataFrom(url: URL) {

        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = NSURLRequest(url: url)

        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, _, error) -> Void in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                    if let results = json["results"] as? [[String:Any]] {
                        results.forEach {
                            if let sh = SuperHero(json: $0) {
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
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}
