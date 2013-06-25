//
//  Work_Order.h
//  sap
//
//  Created by goodcore1 on 6/24/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Work_Order : NSManagedObject

@property (nonatomic, retain) NSNumber * order_id;
@property (nonatomic, retain) NSString * order_type;
@property (nonatomic, retain) NSDate * start_date;
@property (nonatomic, retain) NSDate * end_date;
@property (nonatomic, retain) NSString * priority;
@property (nonatomic, retain) NSString * word_center;
@property (nonatomic, retain) NSString * equipment;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * serial_number;
@property (nonatomic, retain) NSDate * last_updated;
@property (nonatomic, retain) NSString * updated_by;
@property (nonatomic, retain) NSString * notes;

@end
