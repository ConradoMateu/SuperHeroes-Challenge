//
//  SuperHero.swift
//  Challenge
//
//  Created by Conrado Mateu Gisbert on 17/02/17.
//  Copyright © 2017 conradomateu. All rights reserved.
//

import Foundation
import UIKit

struct SuperHero {
    let urlImage: NSURL
    let name: String?
    let alias: String?
    let birthday: String?
    let description: String
    let realname: String?
}
extension SuperHero {
    init?(json: [String: Any]) {
        guard let description = json["description"] as? String,
        let image = json["image"] as? [String:Any],
        let urlImage = image["icon_url"] as?  String,
        let name = json["name"] as? String
        
        else {
                return nil
        }
        let alias = json["aliases"] as? String
        let birth = json["birth"] as? String
        let realname = json["real_name"] as? String
        self.name = name
        self.urlImage = NSURL(string: urlImage)!
        self.alias = alias
        self.birthday = birth
        self.description = description.html2String
        self.realname = realname
    }
    
    
    
}


extension String {
    var html2AttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
