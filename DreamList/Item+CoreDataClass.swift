//
//  Item+CoreDataClass.swift
//  DreamList
//
//  Created by Alwin Lazar on 16/01/17.
//  Copyright © 2017 Xeoscript Technologies. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    // this func called when the Item entity created in any place
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        // when the NSObject is created then assign the current date
        // to the attribute created
        // this create a timeStamp for your item
        self.created = NSDate()
    }

}
