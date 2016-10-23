//
//  FirstViewController.swift
//  TransitionTest
//
//  Created by Jackie Zhang on 16/9/29.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD

class FirstViewController : UITableViewController, NSFetchedResultsControllerDelegate {

    
    var fetchedResultController : NSFetchedResultsController<News>!
    
    var news: [NewsItem]?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! SecondViewController
        if let selectedNews = news?[(tableView.indexPathForSelectedRow?.row)!] {
            destVC.news = selectedNews
        }

    }
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    override func viewDidLoad() {
        
        initializeFetchResultController()
        
        initNews()
        
        refreshNews()

    }
    
    //MARK: - fetch result controller
    func initializeFetchResultController () {
        let fetchRequest : NSFetchRequest<News> = News.fetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        let moc = PersistantStore.shared.context!
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "realtype", cacheName: "newsCache")
        fetchedResultController.delegate = self
        
        }
    
    
    //MARK: - default data loading
    
    func loadNewsFromFetchedController() {
        do {
            
            try self.fetchedResultController.performFetch()
            
            self.tableView.reloadData()
            print ("table reloaded")
            
        } catch let error {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    
    func initNews() {
        
        loadNewsFromFetchedController()

    }
    
    
    
    //MARK: - network loading
    
    func refreshNews() {
       // SVProgressHUD.show(withStatus: "正在加载...")
        
        NetworkManager.sharedManager.loadTopNews(type: .shishang) {
            items in
          //  SVProgressHUD.dismiss()
            
            
            if let newsItems = items {
                print(newsItems.count)
                
                PersistantStore.shared.clearNews()

                for new in newsItems {
                 
                    PersistantStore.shared.addNews(from: new)
                
                }
            
                self.news = newsItems
               
                self.loadNewsFromFetchedController()
            }
        }
        
    }

    
    //MARK: - table view delegate
    
    func configureCell(cell: inout UITableViewCell, forIndexPath indexPath: IndexPath){
        
        let selectedObject = fetchedResultController.object(at: indexPath as IndexPath) as News
        
        cell.textLabel?.text = selectedObject.title
        
        let url = URL(string: selectedObject.thumbnail_pic_s!)!
        cell.imageView?.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder")
            , options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = fetchedResultController.sections {
            return sections.count
        } else {
            return 1
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultController.sections  {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        } else {
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell")!
        configureCell(cell: &cell, forIndexPath: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
