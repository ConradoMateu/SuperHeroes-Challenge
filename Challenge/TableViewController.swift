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
    var superHeroDetail: SuperHero?
    var restApiManager: RestApiManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.restApiManager =  RestApiManager(tableView: self.tableView)
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
        if let img =  self.restApiManager?.superHeroes[indexPath.row].image {
            cell.imageView?.image = img
        }else {
            cell.imageView?.imageFromServerURL(urlString: restApiManager!.superHeroes[indexPath.row].urlImage){ image in self.restApiManager?.superHeroes[indexPath.row].image = image
        }

        }
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            destination.superHero = superHeroDetail
        }
    }

    func completion(_ data: Data?, _ response: URLResponse?, _ error: NSError? ) {
            return
    }
}


extension UIImageView {
    public func imageFromServerURL(urlString: String, completion: @escaping (_ image: UIImage?) -> Void) {

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
                completion(image)
            })

        }).resume()
    }}
