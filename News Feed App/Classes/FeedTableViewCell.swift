//
//  FeedTableViewCell.swift
//  News Feed App
//
//  Created by Lilit Avetisyan on 5/30/18.
//  Copyright © 2018 Lil. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    //MARK: variables and outlets
    
    @IBOutlet var cellImg: UIImageView!
    
    @IBOutlet var cellLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setParams(params: NSDictionary){
        print(params);
        
        print(params["webTitle"]!)
        
        if let title = params["webTitle"]{
            cellLbl?.text = (title as! String)
        }
//        else {
//        cellLbl?.text = params["webTitle"] as! String
//        }
    }

}
