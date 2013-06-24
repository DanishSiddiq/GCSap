//
//  SidebarView.h
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SidebarView : UIView

@property (strong, nonatomic) IBOutlet UIButton* hrBtn;
@property (strong, nonatomic) IBOutlet UIButton* purchaseBtn;
@property (strong, nonatomic) IBOutlet UIButton* financeBtn;
@property (strong, nonatomic) IBOutlet UIButton* maintenancerBtn;
@property (strong, nonatomic) IBOutlet UIButton* workOrderBtn;


- (id)initWithFrame:(CGRect)frame sapDelegate : (AppDelegate *) sapDelegate;

@end
