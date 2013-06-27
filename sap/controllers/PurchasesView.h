//
//  PurchasesView.h
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "PurchasesView.h"
#import "PO_Delivery.h"
#import "PO_Invoice.h"
#import "PO_Items.h"

@interface PurchasesView : UIView <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) Protocol* tableDelegate;
@property (strong, nonatomic) IBOutlet UIButton *btnApproved;
@property (strong, nonatomic) IBOutlet UIButton *btnDeclined;

// overriding the constructor
- (id)initWithFrame:(CGRect)frame sapDelegate : (AppDelegate *) sapDelegate;
- (IBAction)slideBtnPressed:(id)sender;
//selectors
- (IBAction)btnPressedApproved:(id)sender;
- (IBAction)btnPressedDeclined:(id)sender;
- (IBAction)btnPressedPending:(id)sender;
- (IBAction)btnPoApprovedPressed:(id)sender;
- (IBAction)btnPoDeclinedPressed:(id)sender;

-(void) resetDataInViews;

- (void) hideKeyBoard;

@end
