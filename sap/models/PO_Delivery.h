//
//  PO_Delivery.h
//  sap
//
//  Created by goodcore1 on 6/19/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PO_Delivery : NSManagedObject

@property (nonatomic, retain) NSNumber * po_delivery_id;
@property (nonatomic, retain) NSNumber * po_id;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * delivery_type;
@property (nonatomic, retain) NSDate * delivery_date;

@end
