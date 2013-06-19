//
//  SidebarView.m
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import "SidebarView.h"
#import "HRView.h"
#import "FinanceView.h"
#import "MaintenanceView.h"
#import "PurchasesView.h"

@interface SidebarView ()

@property (retain, nonatomic) IBOutlet UIView* sidebarView;


@end

@implementation SidebarView

@synthesize hrBtn;
@synthesize financeBtn;
@synthesize maintenancerBtn;
@synthesize purchaseBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"SidebarView" owner:self options:nil];
        self.sidebarView.frame = frame;
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"NavBg.png"]];
        self.sidebarView.backgroundColor = background;
        
        
        [self addSubview:self.sidebarView];
                
    }
    return self;
}


-(IBAction)hrButtonPressed:(id)sender{
    
    for (UIView *subview in self.superview.subviews)
    {
        if([subview class] == [HRView class]){
            subview.hidden = NO;
        }else if([subview class] != [SidebarView class]){
            subview.hidden = YES;
        }
    }
    
    
    [self.financeBtn setImage:[UIImage imageNamed:@"Finance.png"] forState:UIControlStateNormal];
    [self.purchaseBtn setImage:[UIImage imageNamed:@"purchasing.png"] forState:UIControlStateNormal];
    [self.maintenancerBtn setImage:[UIImage imageNamed:@"Maintenance.png"] forState:UIControlStateNormal];
    
    UIImage* image = [UIImage imageNamed:@"HumanHover.png"];    
    [sender setImage:image forState:UIControlStateNormal];
    
}

-(IBAction)purchaseButtonPressed:(id)sender{
    
    
    for (UIView *subview in self.superview.subviews)
    {
        if([subview class] == [PurchasesView class]){
            subview.hidden = NO;
        }else if([subview class] != [SidebarView class]){
            subview.hidden = YES;
        }
    }
    
    [self.financeBtn setImage:[UIImage imageNamed:@"Finance.png"] forState:UIControlStateNormal];
    [self.hrBtn setImage:[UIImage imageNamed:@"Human.png"] forState:UIControlStateNormal];
    [self.maintenancerBtn setImage:[UIImage imageNamed:@"Maintenance.png"] forState:UIControlStateNormal];
    
    UIImage *image = [UIImage imageNamed:@"purchasingHover.png"];
    [sender setImage:image forState:UIControlStateNormal];
    
}

-(IBAction)financeButtonPressed:(id)sender{
    
    for (UIView *subview in self.superview.subviews)
    {
        if([subview class] == [FinanceView class]){
            subview.hidden = NO;
        }else if([subview class] != [SidebarView class]){
            subview.hidden = YES;
        }
    }
    
    UIImage *image = [UIImage imageNamed:@"FinanceHover.png"];
    [sender setImage:image forState:UIControlStateNormal];
    
    [self.purchaseBtn setImage:[UIImage imageNamed:@"purchasing.png"] forState:UIControlStateNormal];
    [self.hrBtn setImage:[UIImage imageNamed:@"Human.png"] forState:UIControlStateNormal];
    [self.maintenancerBtn setImage:[UIImage imageNamed:@"Maintenance.png"] forState:UIControlStateNormal];
    
}

-(IBAction)maintenanceButtonPressed:(id)sender{
    
    for (UIView *subview in self.superview.subviews)
    {
        if([subview class] == [MaintenanceView class]){
            subview.hidden = NO;
        }else if([subview class] != [SidebarView class]){
            subview.hidden = YES;
        }
    }
    
    UIImage *image = [UIImage imageNamed:@"MaintenanceHover.png"];
    [sender setImage:image forState:UIControlStateNormal];
    
    [self.financeBtn setImage:[UIImage imageNamed:@"Finance.png"] forState:UIControlStateNormal];
    [self.hrBtn setImage:[UIImage imageNamed:@"Human.png"] forState:UIControlStateNormal];
    [self.purchaseBtn setImage:[UIImage imageNamed:@"purchasing.png"] forState:UIControlStateNormal];
}


@end
