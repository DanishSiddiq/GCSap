//
//  main.m
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "Departments.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
        // Custom code here...
        // Save the managed object context
        
        NSError* err = nil;
        NSString* dataPathDepartments = [[NSBundle mainBundle] pathForResource:@"Departments" ofType:@"json"];
        NSArray* departments = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPathDepartments]
                                                               options:kNilOptions
                                                                 error:&err];
        
        NSString* dataPathEmployees = [[NSBundle mainBundle] pathForResource:@"Employees" ofType:@"json"];
        NSArray* employees = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPathEmployees]
                                                               options:kNilOptions
                                                                 error:&err];
        
        NSString* dataPathhrLeaves = [[NSBundle mainBundle] pathForResource:@"HR_leaves" ofType:@"json"];
        NSArray* hr_leaves = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPathhrLeaves]
                                                               options:kNilOptions
                                                                 error:&err];
        
        NSString* dataPathPurhases = [[NSBundle mainBundle] pathForResource:@"Purchase_Order" ofType:@"json"];
        NSArray* purchases = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPathPurhases]
                                                               options:kNilOptions
                                                                 error:&err];
        
//        NSLog(@"Departments %@", departments);
//        NSLog(@"Employees %@", employees);
//        NSLog(@"HR leaves %@", hr_leaves);
//        NSLog(@"Purchase Order %@", purchases);
        
//        // saving departments
//        [departments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            Departments *departmentsObj = [NSEntityDescription
//                                              insertNewObjectForEntityForName:@"Departments"
//                                              inManagedObjectContext:context];
//            departmentsObj.dept_id = [obj objectForKey:@"dept_id"];
//            departmentsObj.dept_name = [obj objectForKey:@"dept_name"];
//            
//            NSError *error;
//            if (![context save:&error]) {
//                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//            }
//        }];
//        
//        // saving employees
//        [employees enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            Departments *departmentsObj = [NSEntityDescription
//                                           insertNewObjectForEntityForName:@"Departments"
//                                           inManagedObjectContext:context];
//            departmentsObj.dept_id = [obj objectForKey:@"dept_id"];
//            departmentsObj.dept_name = [obj objectForKey:@"dept_name"];
//            
//            NSError *error;
//            if (![context save:&error]) {
//                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//            }
//        }];
//        
//        // saving hr_leaves
//        [hr_leaves enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            Departments *departmentsObj = [NSEntityDescription
//                                           insertNewObjectForEntityForName:@"Departments"
//                                           inManagedObjectContext:context];
//            departmentsObj.dept_id = [obj objectForKey:@"dept_id"];
//            departmentsObj.dept_name = [obj objectForKey:@"dept_name"];
//            
//            NSError *error;
//            if (![context save:&error]) {
//                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//            }
//        }];
//        
//        // saving purchase_orders
//        [purchases enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            Departments *departmentsObj = [NSEntityDescription
//                                           insertNewObjectForEntityForName:@"Departments"
//                                           inManagedObjectContext:context];
//            departmentsObj.dept_id = [obj objectForKey:@"dept_id"];
//            departmentsObj.dept_name = [obj objectForKey:@"dept_name"];
//            
//            NSError *error;
//            if (![context save:&error]) {
//                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//            }
//        }];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        
    }
}
