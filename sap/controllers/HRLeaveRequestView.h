//
//  HRLeaveRequest.h
//  sap
//
//  Created by goodcore2 on 6/20/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface HRLeaveRequestView : UIView <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

// constructor
- (id)initWithFrame:(CGRect)frame sapDelegate : (AppDelegate *) sapDelegate;


@end
