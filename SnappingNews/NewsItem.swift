//
//  NewsItem.swift
//  SnappingNews
//
//  Created by Jackie Zhang on 16/10/17.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import Foundation
import HandyJSON

struct Result : HandyJSON{
    var stat: String?
    var data: [NewsItem]?
}



final class NewsItem : HandyJSON{
    
    func setNews(news: inout News) {
            news.author_name = self.author_name
        news.date = self.date
        news.realtype = self.realtype
        news.thumbnail_pic_s = self.thumbnail_pic_s
        news.thumbnail_pic_s02 = self.thumbnail_pic_s02
        news.thumbnail_pic_s03 = self.thumbnail_pic_s03
        news.title = self.title
        news.type = self.type
        news.uniquekey = self.uniquekey
        news.url = self.url


    }
    
     public var author_name: String?
     public var date: String?
     public var realtype: String?
     public var thumbnail_pic_s: String?
     public var thumbnail_pic_s02: String?
     public var thumbnail_pic_s03: String?
     public var title: String?
     public var type: String?
     public var uniquekey: String?
     public var url: String?
    
}
