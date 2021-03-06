//
//  HRView.h
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "HR_leaves.h"
#import "HRLeaveRequestView.h"
#import "HRLeaveApprovalView.h"


@interface HRView : UIView <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>


// constructor
- (id)initWithFrame:(CGRect)frame sapDelegate : (AppDelegate *) sapDelegate;

- (IBAction)btnPressedSlide:(id)sender;
- (IBAction)btnPressedLeaveRequest:(id)sender;
- (IBAction)btnPressedLeaveApproval:(id)sender;



// protocol implementation
- (void) resetDataInViews;
- (void) hideKeyBoard;

@end
