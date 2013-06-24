//
//  AppDelegate.m
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import "AppDelegate.h"

#import "RootViewController.h"


@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _managedObjectContext = [self managedObjectContext];
    
    NSError *error;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HR_leaves"
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if([fetchedObjects count] <= 0){
        
        [self populateWithPrerequisiteData];
    }
    else{
        
        for (Employees *info in fetchedObjects) {
            //NSLog(@"emp_name: %@", info.emp_name);
        }
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void) populateWithPrerequisiteData {
    
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
    
    NSString* dataPathPO_Invoices = [[NSBundle mainBundle] pathForResource:@"PO_Invoice" ofType:@"json"];
    NSArray* po_invoivces = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPathPO_Invoices]
                                                         options:kNilOptions
                                                           error:&err];
    
    NSString* dataPathPO_Delivery = [[NSBundle mainBundle] pathForResource:@"PO_Delivery" ofType:@"json"];
    NSArray* po_delivery = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPathPO_Delivery]
                                                         options:kNilOptions
                                                           error:&err];
    
    NSString* dataPathPOItems = [[NSBundle mainBundle] pathForResource:@"PO_Items" ofType:@"json"];
    NSArray* po_items = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPathPOItems]
                                                         options:kNilOptions
                                                           error:&err];
    
    NSString* dataPathWorkOrder = [[NSBundle mainBundle] pathForResource:@"Work_Order" ofType:@"json"];
    NSArray* work_order = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPathWorkOrder]
                                                        options:kNilOptions
                                                          error:&err];
    //NSLog(@"Items: %@", employees);
    //NSLog(@"Items: %@", po_items);
    
    // saving departments
    [departments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Departments *departmentsObj = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"Departments"
                                       inManagedObjectContext:_managedObjectContext];
        departmentsObj.dept_id = [obj objectForKey:@"dept_id"];
        departmentsObj.dept_name = [obj objectForKey:@"dept_name"];
        
        NSError *error;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Error saving Department: %@", [error localizedDescription]);
        }
    }];
    
    // saving employees
    [employees enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Employees *empObj = [NSEntityDescription
                             insertNewObjectForEntityForName:@"Employees"
                             inManagedObjectContext:_managedObjectContext];
        empObj.emp_id = [obj objectForKey:@"emp_id"];
        empObj.emp_name = [obj objectForKey:@"emp_name"];
        empObj.emp_number = [obj objectForKey:@"emp_number"];
        empObj.dept_id = [obj objectForKey:@"dept_id"];
        empObj.dept_head = [NSNumber numberWithLongLong:[[obj objectForKey:@"dept_head"] longLongValue]];
        
        NSError *error;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Error saving Employee: %@", [error localizedDescription]);
        }
    }];
    
    // saving hr_leaves
    [hr_leaves enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HR_leaves *hrObj = [NSEntityDescription
                            insertNewObjectForEntityForName:@"HR_leaves"
                            inManagedObjectContext:_managedObjectContext];
        hrObj.leave_id = [obj objectForKey:@"leave_id"];
        hrObj.dept_id = [obj objectForKey:@"dept_id"];
        hrObj.leave_type = [obj objectForKey:@"leave_type"];
        hrObj.applied_date = [self convertStringToDate: [obj objectForKey:@"applied_date"]];
        hrObj.from_date = [self convertStringToDate:[obj objectForKey:@"from_date"]];
        hrObj.to_date = [self convertStringToDate:[obj objectForKey:@"to_date"]];
        hrObj.submitted =  [NSNumber numberWithLongLong:[[obj objectForKey:@"submitted"] longLongValue]];
        hrObj.approver = [obj objectForKey:@"approver"];
        hrObj.emp_number = [obj objectForKey:@"emp_number"];
        hrObj.emp_name = [obj objectForKey:@"emp_name"];
        hrObj.approved = [NSNumber numberWithLongLong:[[obj objectForKey:@"approved"] longLongValue]];
        hrObj.isProcessed = [NSNumber numberWithLongLong:[[obj objectForKey:@"isProcessed"] longLongValue]];
        hrObj.notes = [obj objectForKey:@"notes"];
        
        NSError *error;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Error saving HR leave: %@", [error localizedDescription]);
        }
    }];
    
    // saving purchase_orders
    [purchases enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Purchase_Orders *purchaseObj = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"Purchase_Orders"
                                        inManagedObjectContext:_managedObjectContext];
        purchaseObj.po_id = [obj objectForKey:@"po_id"];
        purchaseObj.po_date = [self convertStringToDate:[obj objectForKey:@"po_date"]];
        purchaseObj.vendor = [obj objectForKey:@"vendor"];
        purchaseObj.amount = [obj objectForKey:@"amount"];
        purchaseObj.currency = [obj objectForKey:@"currency"];
        purchaseObj.order_type = [obj objectForKey:@"order_type"];
        purchaseObj.approved = [NSNumber numberWithLongLong:[[obj objectForKey:@"approved"] longLongValue]];
        purchaseObj.declined = [NSNumber numberWithLongLong:[[obj objectForKey:@"declined"] longLongValue]];
        
        NSError *error;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Error saving Purchase: %@", [error localizedDescription]);
        }
    }];
    
    // saving purchase_orders invoice
    [po_invoivces enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PO_Invoice *poInvoiceObj = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"PO_Invoice"
                                    inManagedObjectContext:_managedObjectContext];
        
        poInvoiceObj.po_id = [NSNumber numberWithLongLong:[[obj objectForKey:@"po_id"] longLongValue]];
        poInvoiceObj.invoice_date = [self convertStringToDate:[obj objectForKey:@"invoice_date"]];
        poInvoiceObj.po_invoice_id = [NSNumber numberWithLongLong:[[obj objectForKey:@"po_invoice_id"] longLongValue]];
        poInvoiceObj.amount = [NSNumber numberWithLongLong:[[obj objectForKey:@"amount"] longLongValue]];
        
        NSLog(@"OBJ: %@", poInvoiceObj);
        NSError *error;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Error saving PO Invoice: %@", [error localizedDescription]);
        }
    }];

    
    // saving purchase_orders items
    [po_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PO_Items *poItemsObj = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"PO_Items"
                                        inManagedObjectContext:_managedObjectContext];
        poItemsObj.po_items_id = [NSNumber numberWithLongLong:[[obj objectForKey:@"po_Items_id"] longLongValue]];
        poItemsObj.po_id = [NSNumber numberWithLongLong:[[obj objectForKey:@"po_id"] longLongValue]];
        poItemsObj.delivery_date = [self convertStringToDate:[obj objectForKey:@"delivery_date"]];
        poItemsObj.items = [obj objectForKey:@"items"];
        poItemsObj.quantity = [NSNumber numberWithLongLong:[[obj objectForKey:@"quantity"] longLongValue]];
        poItemsObj.units = [obj objectForKey:@"units"];
        poItemsObj.l = [NSNumber numberWithLongLong:[[obj objectForKey:@"l"] longLongValue]];
        poItemsObj.a = [NSNumber numberWithLongLong:[[obj objectForKey:@"a"] longLongValue]];
        poItemsObj.short_text = [obj objectForKey:@"short_text"];
        poItemsObj.material = [obj objectForKey:@"material"];
        
        NSLog(@"OBJ: %@", poItemsObj);
        NSError *error;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Error saving PO Item: %@", [error localizedDescription]);
        }
    }];
    
    // saving purchase_orders delivery
    [po_delivery enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PO_Delivery *poDeliveryObj = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"PO_Delivery"
                                        inManagedObjectContext:_managedObjectContext];
        poDeliveryObj.po_id = [NSNumber numberWithLongLong:[[obj objectForKey:@"po_id"] longLongValue]];
        poDeliveryObj.delivery_date = [self convertStringToDate:[obj objectForKey:@"delivery_date"]];
        poDeliveryObj.delivery_type = [obj objectForKey:@"delivery_type"];
        poDeliveryObj.po_delivery_id = [NSNumber numberWithLongLong:[[obj objectForKey:@"po_delivery_id"] longLongValue]];
        poDeliveryObj.status = [NSNumber numberWithLongLong:[[obj objectForKey:@"status"] longLongValue]];
        
        //NSLog(@"OBJ: %@", poDeliveryObj);
        NSError *error;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Error saving PO Delivery: %@", [error localizedDescription]);
        }
    }];
    
    // saving work order
    [work_order enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Work_Order *workOrderObj = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Work_Order"
                                      inManagedObjectContext:_managedObjectContext];
        workOrderObj.order_id = [NSNumber numberWithLongLong:[[obj objectForKey:@"order_id"] longLongValue]];
        workOrderObj.start_date = [self convertStringToDate:[obj objectForKey:@"start_date"]];
        workOrderObj.end_date = [self convertStringToDate:[obj objectForKey:@"end_date"]];
        workOrderObj.last_updated = [self convertStringToDate:[obj objectForKey:@"last_updated"]];
        workOrderObj.equipment = [obj objectForKey:@"equipment"];
        workOrderObj.serial_number = [obj objectForKey:@"serial_number"];
        workOrderObj.word_center = [obj objectForKey:@"word_center"];
        workOrderObj.updated_by = [obj objectForKey:@"updated_by"];
        workOrderObj.order_type = [obj objectForKey:@"order_type"];
        workOrderObj.priority = [obj objectForKey:@"priority"];
        workOrderObj.status = [NSNumber numberWithLongLong:[[obj objectForKey:@"status"] longLongValue]];
        
        NSLog(@"OBJ: %@", workOrderObj);
        NSError *error;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Error saving Work Order: %@", [error localizedDescription]);
        }
    }];
    
}

- (NSDate *) convertStringToDate : (NSString *) strDate {
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSDate* date = [df dateFromString:strDate];

    //NSLog(@"%@", date);
    
    return date;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"sapDatabase" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSError *error = nil;
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"sapDatabase.sqlite"];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
