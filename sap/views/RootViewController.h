//
//  RootViewController.h
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SidebarView.h"
#import "HRView.h"
#import "FinanceView.h"
#import "MaintenanceView.h"
#import "PurchasesView.h"
#import "WorkOrderView.h"
#import "DashboardView.h"
#import "SVProgressHUD.h"


@class SidebarView;

@protocol RootViewDelegate <NSObject>

@required
- (void) resetDataInViews;
- (void) hideKeyBoard;

@end

@interface RootViewController : UIViewController <RootViewDelegate>


- (void) showSplashScreen;
- (void) resetDataInViews;
- (void) hideKeyBoard;

@end
