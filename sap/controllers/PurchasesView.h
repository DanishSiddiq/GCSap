//
//  PurchasesView.h
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PurchasesView.h"
#import "PO_Delivery.h"
#import "PO_Invoice.h"
#import "PO_Items.h"

@interface PurchasesView : UIView <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>


// overriding the constructor
- (id)initWithFrame:(CGRect)frame sapDelegate : (AppDelegate *) sapDelegate;
- (IBAction)slideBtnPressed:(id)sender;

@end
