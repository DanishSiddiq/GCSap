//
//  AppDelegate.h
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Departments.h"
#import "Employees.h"
#import "HR_leaves.h"
#import "Purchase_Orders.h"
#import "PO_Delivery.h"
#import "PO_Invoice.h"
#import "PO_Items.h"
#import "Work_Order.h"

@class RootViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RootViewController *viewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


// to delete all core data
- (BOOL) purgeAllObjects;
- (void) populateWithPrerequisiteData ;

@end
