//
//  Employees.h
//  sap
//
//  Created by goodcore1 on 6/18/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Employees : NSManagedObject

@property (nonatomic, retain) NSNumber * emp_id;
@property (nonatomic, retain) NSString * emp_name;
@property (nonatomic, retain) NSNumber * dept_id;
@property (nonatomic, retain) NSNumber * dept_head;

@end
