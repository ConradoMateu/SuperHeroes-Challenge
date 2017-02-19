//
//  DetailViewController.swift
//  Challenge
//
//  Created by Conrado Mateu Gisbert on 17/02/17.
//  Copyright © 2017 conradomateu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    var superHero: SuperHero?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    func configure(){
        descriptionLabel.text = superHero!.description
        realNameLabel.text = superHero?.realname ?? "No tiene nombre real"
        birthdayLabel.text = superHero?.birthday ?? "No tiene cumpleaños"
    }
    
    
    

}
