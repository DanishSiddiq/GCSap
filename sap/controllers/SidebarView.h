//
//  SidebarView.h
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidebarView : UIView

@property (strong, nonatomic) IBOutlet UIButton* hrBtn;
@property (strong, nonatomic) IBOutlet UIButton* purchaseBtn;
@property (strong, nonatomic) IBOutlet UIButton* financeBtn;
@property (strong, nonatomic) IBOutlet UIButton* maintenancerBtn;
@property (strong, nonatomic) IBOutlet UIButton* workOrderBtn;

-(IBAction)hrButtonPressed:(id)sender;
-(IBAction)purchaseButtonPressed:(id)sender;
-(IBAction)financeButtonPressed:(id)sender;
-(IBAction)maintenanceButtonPressed:(id)sender;
-(IBAction)workOrderButtonPressed:(id)sender;

@end
