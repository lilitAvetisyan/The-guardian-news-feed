//
//  FeedViewController.swift
//  News Feed App
//
//  Created by Lilit Avetisyan on 5/30/18.
//  Copyright © 2018 Lil. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "News feed"
        self.getInfoDict()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: variables
    var infoArr = NSArray()
    
    @IBOutlet var feedTbl: UITableView!

    //MARK: methods

    //MARK: tableview Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.infoArr.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        cell.setParams(params: infoArr[indexPath.row] as! NSDictionary)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArticleViewController") as! ArticleViewController
        vc.articleInfo = infoArr[indexPath.row] as! NSDictionary
        navigationController?.pushViewController(vc, animated: false)
        
    }
    
    //TODO: make the function return dicntionary
    func getInfoDict(){
        
        let url = URL(string: "https://content.guardianapis.com/search?api-key=be9ee230-4a45-4e17-9408-12242d058d78&show-fields=all")
        
        if let usableUrl = url {
            var request = URLRequest(url: usableUrl)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error as Any)
                } else {
                    do {
                        
                        let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                        print(parsedData)
                        
                        
                        let responeDict = parsedData["response"] as! NSDictionary
                        self.infoArr = responeDict["results"] as! NSArray
                        print(self.infoArr)
                    } catch let error as NSError {
                        print(error)
                    }
                }
                DispatchQueue.main.async {
                    self.feedTbl.reloadData()
                }


            })
            task.resume()
        }
    
    }

}


