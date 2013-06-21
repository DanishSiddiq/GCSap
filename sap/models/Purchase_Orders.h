//
//  Purchase_Orders.h
//  sap
//
//  Created by goodcore1 on 6/18/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Purchase_Orders : NSManagedObject

@property (nonatomic, retain) NSNumber * po_id;
@property (nonatomic, retain) NSString * vendor;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSDate * po_date;
@property (nonatomic, retain) NSString * order_type;
@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSNumber * approved;
@property (nonatomic, retain) NSNumber * declined;

@end
