//
//  BucketEntity+CoreDataProperties.swift
//  BucketwithCoreData
//
//  Created by admin on 18/12/2021.
//
//

import Foundation
import CoreData


extension BucketEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BucketEntity> {
        return NSFetchRequest<BucketEntity>(entityName: "BucketEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var bucketdesc: String?

}

extension BucketEntity : Identifiable {

}
