//
//  FinanceView.h
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface FinanceView : UIView

- (id)initWithFrame:(CGRect)frame sapDelegate : (AppDelegate *) sapDelegate;
- (IBAction)slideBtnPressed:(id)sender;

@end
