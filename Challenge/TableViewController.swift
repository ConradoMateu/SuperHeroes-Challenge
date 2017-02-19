//
//  TableViewController.swift
//  Challenge
//
//  Created by Conrado Mateu Gisbert on 17/02/17.
//  Copyright © 2017 conradomateu. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    @IBOutlet var tb: UITableView!
    var SuperHeroes: [SuperHero] = [SuperHero]()
    var superHeroDetail: SuperHero?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SuperHeroes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        superHeroDetail = SuperHeroes[indexPath.row]
        performSegue(withIdentifier: "Detail", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) 
        cell.detailTextLabel?.text = self.SuperHeroes[indexPath.row].alias ?? ""
        
        cell.textLabel?.text = self.SuperHeroes[indexPath.row].name
        downloadImage(self.SuperHeroes[indexPath.row].urlImage as URL, tableview: cell)
        
        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            
            destination.superHero = superHeroDetail
            
        }
    }
    
    
    func initData() {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let apiKey = valueForAPIKey(named: "API_KEY")
        let request = NSURLRequest(url: NSURL(string: "http://comicvine.gamespot.com/api/characters?api_key=" + apiKey + "&format=json")! as URL)
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                    if let all = json["results"] as? [[String:Any]] {
                        
                        all.forEach{
                            if let sh = SuperHero(json: $0){
                                self.SuperHeroes.append(sh)
                            }
                            
                        }
                        DispatchQueue.main.async{
                            self.tb.reloadData()
                        }
                        
                    }
                    
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
        }
        
        task.resume()
        
        
        
    }
    
    
    
    func valueForAPIKey(named keyname:String) -> String {
        let filePath = Bundle.main.path(forResource: "ApiKey", ofType: "plist")
        let plist = NSDictionary(contentsOfFile:filePath!)
        let value = plist?.object(forKey: keyname) as! String
        print(value)
        return value
    }
    
    func getDataFromUrl(_ url:URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: NSError? ) -> Void)) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            completion(data, response, error as NSError?)
            return()}).resume()
    }
    
    func downloadImage(_ url: URL, tableview: UITableViewCell){
        getDataFromUrl(url) { (data, response, error)  in
            DispatchQueue.main.async { () -> Void in
                guard let data = data , error == nil else { return }
                tableview.imageView?.image =  UIImage(data: data)
            }
        }
       
    }

    }
