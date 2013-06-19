//
//  PO_Items.h
//  sap
//
//  Created by goodcore1 on 6/19/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PO_Items : NSManagedObject

@property (nonatomic, retain) NSNumber * po_items_id;
@property (nonatomic, retain) NSNumber * po_id;
@property (nonatomic, retain) NSString * items;
@property (nonatomic, retain) NSNumber * a;
@property (nonatomic, retain) NSNumber * l;
@property (nonatomic, retain) NSString * material;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * units;
@property (nonatomic, retain) NSDate * delivery_date;
@property (nonatomic, retain) NSString * short_text;

@end
