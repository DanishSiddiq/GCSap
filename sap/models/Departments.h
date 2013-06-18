//
//  Departments.h
//  sap
//
//  Created by goodcore1 on 6/18/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Departments : NSManagedObject

@property (nonatomic, retain) NSNumber * dept_id;
@property (nonatomic, retain) NSString * dept_name;

@end
