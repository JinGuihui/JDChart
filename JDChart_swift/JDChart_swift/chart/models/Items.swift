//
//  Items.swift
//  JDChart_swift
//
//  Created by liuhang on 17/7/4.
//  Copyright © 2017年 liuhang. All rights reserved.

import Foundation
import SwiftyJSON

class Items: NSObject {
    //cell的高度
    var cellHeaderHeight: CGFloat = 30
    var itemsCellHeight: CGFloat = 0
    var items : [Item]!
    var discount : Double!
    var checkType : Int!
    var needMoney : Double!
    var gifts : [Gift]!
    var Id : String!
    var suitType : Int!
    var promotionId : String!
    var suitLabel : String!
    var num : Int!
    var point : Int!
    var price : Double!
    var entryLabel : String!
    var priceShow : String!
    var rePrice : Double!
    var canSelectGifts : [AnyObject]!
    var skus : [AnyObject]!
    var isReachCondition : Bool!
    var sType : Int!
    var specialId : String!
    var sTip : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        items = [Item]()
        let itemsArray = json["items"].arrayValue
        for itemsJson in itemsArray{
            let itemJson = itemsJson["item"]
                let value = Item(fromJson: itemJson)
                items.append(value)
        }
        checkType = json["CheckType"].intValue
        discount = json["Discount"].doubleValue
        gifts = [Gift]()
        let giftsArray = json["Gifts"].arrayValue
        for giftJson in giftsArray{
            let value = Gift(fromJson: giftJson)
            print(value)
            gifts.append(value)
        }

        needMoney = json["NeedMoney"].doubleValue
        Id = json["Id"].stringValue
        suitType = json["suitType"].intValue
        promotionId = json["promotionId"].stringValue
        suitLabel = json["suitLabel"].stringValue

        num = json["Num"].intValue
        point = json["Point"].intValue
        price = json["Price"].doubleValue
        priceShow = json["PriceShow"].stringValue
        entryLabel = json["entryLabel"].stringValue

        rePrice = json["RePrice"].doubleValue
        canSelectGifts = [AnyObject]()
        let canSelectGiftsArray = json["CanSelectGifts"].arrayValue
        for canSelectGiftsJson in canSelectGiftsArray{
            canSelectGifts.append(canSelectGiftsJson.stringValue as AnyObject)
        }
        skus = [AnyObject]()
        let skusArray = json["Skus"].arrayValue
        for skusJson in skusArray{
            skus.append(skusJson.stringValue as AnyObject)
        }
        isReachCondition = json["isReachCondition"].boolValue
        sType = json["SType"].intValue
        specialId = json["specialId"].stringValue
        sTip = json["STip"].stringValue
        //计算高度
        for singleItem in items {
            itemsCellHeight += singleItem.itemCellHeight
        }
        itemsCellHeight += cellHeaderHeight
    }

}
