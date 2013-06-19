//
//  PO_Invoice.h
//  sap
//
//  Created by goodcore1 on 6/19/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PO_Invoice : NSManagedObject

@property (nonatomic, retain) NSNumber * po_invoice_id;
@property (nonatomic, retain) NSNumber * po_id;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSDate * invoice_date;

@end
