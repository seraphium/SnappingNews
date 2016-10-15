//
//  News+CoreDataProperties.swift
//  SnappingNews
//
//  Created by Jackie Zhang on 2016/10/15.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News");
    }

    @NSManaged public var title: String?
    @NSManaged public var date: String?
    @NSManaged public var thumbnail_pic_s: String?
    @NSManaged public var author_name: String?
    @NSManaged public var thumbnail_pic_s02: String?
    @NSManaged public var thumbnail_pic_s03: String?
    @NSManaged public var url: String?
    @NSManaged public var uniquekey: String?
    @NSManaged public var type: String?
    @NSManaged public var realtype: String?

}
