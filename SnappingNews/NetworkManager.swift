//
//  NetworkManager.swift
//  TransitionTest
//
//  Created by Jackie Zhang on 2016/10/7.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import Alamofire
import SwiftyJSON
import HandyJSON

 let BASE_URL = "https://v.juhe.cn/toutiao/index?"
 let APP_KEY = "9048229b1548ddca34a74d1d57bf9280"

enum NewsType :String {
    case new
    case shehui
    case guonei
    case guoji
    case yule
    case tiyu
    case junshi
    case keji
    case caijing
    case shishang
}

class NetworkManager {
    
static let sharedManager = NetworkManager()
    
    func loadTopNews(type:NewsType, finished: @escaping ([NewsItem]?) -> ()) {
        let params : Parameters = ["type": type.rawValue,
                      "key": APP_KEY]
        Alamofire.request(BASE_URL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseString {response in
            
            if response.result.isSuccess
            {
                let value = response.result.value!
                if let loadedItems = JSONDeserializer<Result>.deserializeFrom(json: value, designatedPath: "result")
                {
                    finished(loadedItems.data)
                }

            }
            
        }
    
        
        
    }


}
