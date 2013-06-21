//
//  HR_leaves.h
//  sap
//
//  Created by goodcore1 on 6/18/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HR_leaves : NSManagedObject

@property (nonatomic, retain) NSNumber * leave_id;
@property (nonatomic, retain) NSString * leave_type;
@property (nonatomic, retain) NSDate * applied_date;
@property (nonatomic, retain) NSDate * from_date;
@property (nonatomic, retain) NSDate * to_date;
@property (nonatomic, retain) NSString * approver;
@property (nonatomic, retain) NSString * emp_number;
@property (nonatomic, retain) NSString * emp_name;
@property (nonatomic, retain) NSNumber * approved;
@property (nonatomic, retain) NSNumber * submitted;
@property (nonatomic, retain) NSNumber * isProcessed;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * dept_id;

@end
