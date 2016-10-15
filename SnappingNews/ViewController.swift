//
//  ViewController.swift
//  SnappingNews
//
//  Created by Jackie Zhang on 2016/10/15.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit
import HandyJSON
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.saveData()

        self.fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func saveData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let news = News(context: context)
        
        news.title = "test"
        news.author_name = "zz"
        news.uniquekey = "avdsv43"
        
        do {
            try context.save()
        } catch let error {
            print ("context saving failed:\(error)")
        }
    }

    func fetchData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<News> = News.fetchRequest()
        
        do {
            let newsList = try context.fetch(fetchRequest)
            
            for new in newsList {
                print (new.title)
            }
        } catch let error {
            print("fetch data failed \(error)")
        }
    }

}

