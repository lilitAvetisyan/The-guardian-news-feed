//
//  ArticleViewController.swift
//  News Feed App
//
//  Created by Lilit Avetisyan on 5/30/18.
//  Copyright © 2018 Lil. All rights reserved.
//

import UIKit
//import ReadabilityKit


class ArticleViewController: UIViewController {

    @IBOutlet var topWordView: UIView!
    @IBOutlet var titlelbl: UILabel!
    
    @IBOutlet var articleCategory: UILabel!
    @IBOutlet var articleTime: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var text: UILabel!
    
    var articleInfo = NSDictionary()
    var articleBody = NSString()
    var occurances = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fieldsDict = articleInfo["fields"] as! NSDictionary
        self.articleBody = fieldsDict["bodyText"] as! NSString
        
        titlelbl?.text = (articleInfo["webTitle"] as! String)
//        text.backgroundColor = UIColor.red
        text.isHidden = false;
        text.text = articleBody as! String
        text.textColor = UIColor.black

        let bodyArr = self.strToArr(str: articleBody as NSString)
        print(bodyArr)
        occurances = self.arrOccuranceCount(arr: bodyArr)
        print(occurances) // return words with more than 10 occurances
        self.updateOccurenceVew(occur: occurances)
        
        // sets tags
        print(articleInfo["webTitle"]! )
        let tagArr = self.strToArr(str: articleInfo["webTitle"] as! NSString)
        self.setTags(arr: tagArr)
        
        
        self.setArticleTime()
        self.setArticelCategory()
    }

    func setTags(arr: NSArray) {
        print(arr)
        var tagsArr : [String] = []
        var newArr = arr
        for index in 1...3{
        if let max = newArr.max(by: {($1 as! String).count > ($0 as! String).count}) {
//                print(max as! String)
            newArr = newArr.filter() { ($0 as! String) != (max as! String) } as NSArray
                tagsArr.append(max as! String)
            
        }
        }
        print(tagsArr)
        
        for index in 0...tagsArr.count-1 {
            var label = UILabel()
            let xPoint:Int = Int(titlelbl.frame.origin.x)
            label.frame = CGRect(x:xPoint + index*105, y: Int(titlelbl.frame.size.height+50), width: 100, height: 21)

            label.text = tagsArr[index]
            label.textAlignment = NSTextAlignment.center
            label.layer.cornerRadius = 60
            label.backgroundColor = UIColor.lightGray
            scrollView.addSubview(label)
        }
        
    }
    
    func updateOccurenceVew(occur: [String: Int]){
        
        
        for(key,value) in occur{
            
            let index = Array(occur.keys).index(of: key)
            let button = UIButton()
            print(topWordView.frame.origin.y)
            print(topWordView.frame.origin.x)
            button.frame = CGRect(x: 0, y: 30 + index!*20 , width: Int(topWordView.frame.size.width-70), height: 20)
            button.backgroundColor = UIColor.clear
            button.setTitle("\(key) : (\(value))", for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.tag = index!;
            button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
            
            topWordView.addSubview(button)
            
        }
        print("height before: \(topWordView.frame.size.height)")
        topWordView.frame = CGRect(x: topWordView.frame.origin.x, y: topWordView.frame.origin.y, width: topWordView.frame.size.width, height: CGFloat(20*occur.count + 200));
        topWordView.backgroundColor = UIColor.lightGray
        print("height after: \(topWordView.frame.size.height)")

        // does not change height
        if occur.count == 0 {
            topWordView.isHidden = true;
        }
    }
    
    @objc func buttonClicked(sender:UIButton)
    {
        print(sender.tag)
        let string = articleBody as String
        let mutableAttributedString = NSMutableAttributedString(string: string)
        let searchString = Array(occurances.keys)[sender.tag]
        var rangeToSearch = string.startIndex..<string.endIndex
        while let matchingRange = string.range(of: searchString, options: [], range: rangeToSearch) {
            mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: NSRange(matchingRange, in: string))
            rangeToSearch = matchingRange.upperBound..<string.endIndex
        }
        // does not change color fully
//        mutableAttributedString.mutableString.setString(string)
        text?.attributedText = mutableAttributedString
        
}
    
    
    func strToArr(str: NSString) -> NSArray {
        let seperators = CharacterSet(charactersIn: ";:,.-' \"~`<>?/0123456789+_)(*&^%$#@!][{}\\")
        let array = str.components(separatedBy: seperators)
        let newArr = array.filter { $0 != "" }

        return newArr as NSArray
    }
    
    func arrOccuranceCount(arr: NSArray) -> [String: Int]  {

        var wordCounts = [String: Int]()
        for word in arr {
            if wordCounts[word as! String] == nil {
                wordCounts[word as! String] = 1
            } else {
                wordCounts[word as! String]! += 1
            }
        }
        
        var finalWordCounts = [String: Int]()
        
        for (key, value) in wordCounts{
            if wordCounts[key]! > 10{
                finalWordCounts[key] = wordCounts[key]
            }
        }
 
        return finalWordCounts
    }
    
    
    func setArticelCategory() {
        //
        articleCategory.text = articleInfo["sectionName"] as! String
    }
    
    func setArticleTime() {
        var userCalendar = Calendar.current
        userCalendar.timeZone = TimeZone.current
        let requestedComponent: Set<Calendar.Component> = [.hour]
        let publicationTime = articleInfo["webPublicationDate"] as! String;
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd'T'HH:mm:ss'Z'"
        var date = dateFormatter.date(from: publicationTime)
        let startTime = Date()
        let endTime = date
        let timeDifference = userCalendar.dateComponents(requestedComponent, from: endTime!, to: startTime)
        print(timeDifference)
        let newDate = Calendar(identifier: .gregorian).date(from: timeDifference)
        dateFormatter.dateFormat = "HH:mm:ss"
        let dateString =  dateFormatter.string(from: newDate!)
        let newStr = dateString.prefix(2)
        print(newStr)
        articleTime.text = "\(newStr) hours ago"
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
}

