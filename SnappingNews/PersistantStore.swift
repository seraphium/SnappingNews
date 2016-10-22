//
//  PersistantStore.swift
//  SnappingNews
//
//  Created by Jackie Zhang on 16/10/17.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit
import CoreData
import HandyJSON

class PersistantStore {
    
    static let shared = PersistantStore()
    let context: NSManagedObjectContext!
    init() {
        let appdel = UIApplication.shared.delegate as! AppDelegate
        context = appdel.persistentContainer.viewContext
    
    }
    
    
    
    func addNews(from item: NewsItem) -> Bool {
        var news = NSEntityDescription.insertNewObject(forEntityName: "News", into: context) as! News
        item.setNews(news: &news)
        do {
            try context.save()
        } catch let error {
            print("add news failed:\(error)")
            return false
        }
        
        return true
    }
    
    func fetchNews() -> [News]? {
        let fetchRequest : NSFetchRequest<News> = News.fetchRequest()
        var news: [News]?
        do {
            let result  = try context.fetch(fetchRequest) 
            news = result
        }  catch let error {
            print ("fetch News error:\(error)")
        }
        return news
    }

    func clearNews() {
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "News")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            
        } catch let error {
            print ("delete error:\(error)")
        }
        
    }
    
}
