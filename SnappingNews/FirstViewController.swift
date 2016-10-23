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
    
    func pullRefresh() {
        refreshNews()
        self.refreshControl?.endRefreshing()
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
    
    func configureCell(cell: inout NewsCell, forIndexPath indexPath: IndexPath){
        
        let selectedObject = fetchedResultController.object(at: indexPath as IndexPath) as News
        
        cell.newsTitle.text = selectedObject.title
        
        if let url1 = selectedObject.thumbnail_pic_s {
            cell.image1.kf.setImage(with:  URL(string: url1)!, placeholder: #imageLiteral(resourceName: "placeholder")
                , options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
            
        }
        
        if let url2 = selectedObject.thumbnail_pic_s02 {

            cell.image2.kf.setImage(with:  URL(string: url2)!, placeholder: #imageLiteral(resourceName: "placeholder")
            , options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
        }
        
        if let url3 = selectedObject.thumbnail_pic_s03 {

            cell.image3.kf.setImage(with:  URL(string: url3)!, placeholder: #imageLiteral(resourceName: "placeholder")
            , options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
        }

        
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
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") as! NewsCell
        configureCell(cell: &cell, forIndexPath: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
