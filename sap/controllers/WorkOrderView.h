//
//  WorkOrder.h
//  sap
//
//  Created by goodcore1 on 6/24/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface WorkOrderView : UIView <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>


@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnOverview;
@property (strong, nonatomic) IBOutlet UIButton *btnOperations;
@property (strong, nonatomic) IBOutlet UIButton *btnComponents;
@property (strong, nonatomic) IBOutlet UIButton *btnBusiness;
@property (strong, nonatomic) IBOutlet UIButton *btnMaterial;

// overriding the constructor
- (id)initWithFrame:(CGRect)frame sapDelegate : (AppDelegate *) sapDelegate;
- (IBAction)slideBtnPressed:(id)sender;
- (IBAction)btnSubmitPressed:(id)sender;
- (IBAction)btnCancelPressed:(id)sender;

- (IBAction)btnTabPressed:(id)sender;

@end
