//
//  TableViewController.swift
//  Challenge
//
//  Created by Conrado Mateu Gisbert on 17/02/17.
//  Copyright © 2017 conradomateu. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    // MARK: - Vars
    @IBOutlet var tb: UITableView!
    
    var superHeroDetail: SuperHero?
    var restApiManager:RestApiManager? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.restApiManager =  RestApiManager(tableView: tb)
        self.restApiManager?.initialize()
    }
   
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restApiManager!.getSuperHeroes().count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        superHeroDetail = restApiManager!.getSuperHeroes()[indexPath.row]
        performSegue(withIdentifier: "Detail", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) 
        cell.detailTextLabel?.text = restApiManager!.getSuperHeroes()[indexPath.row].alias ?? ""
        
        cell.textLabel?.text = restApiManager!.getSuperHeroes()[indexPath.row].name
        
        downloadImage(restApiManager!.getSuperHeroes()[indexPath.row].urlImage as URL, tableview: cell)
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            
            destination.superHero = superHeroDetail
            
        }
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
