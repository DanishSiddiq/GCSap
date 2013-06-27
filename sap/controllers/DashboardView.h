//
//  DashboardView.h
//  sap
//
//  Created by goodcore1 on 6/27/13.
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

@interface DashboardView : UIView

- (id)initWithFrame:(CGRect)frame sapDelegate : (AppDelegate *) sapDelegate;

@end
