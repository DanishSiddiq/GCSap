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
#import "WorkOrderView.h"

@interface SidebarView ()

@property (nonatomic, strong) AppDelegate *sapDelegate;
@property (retain, nonatomic) IBOutlet UIView* sidebarView;
@property (retain, nonatomic) UIView* rootView;
@property (retain, nonatomic) id hrView;

-(IBAction) hrButtonPressed:(id)sender;
-(IBAction) purchaseButtonPressed:(id)sender;
-(IBAction) financeButtonPressed:(id)sender;
-(IBAction) maintenanceButtonPressed:(id)sender;
-(IBAction) workOrderButtonPressed:(id)sender;
-(IBAction) btnPressedResetData :(id)sender;

@end

@implementation SidebarView

@synthesize hrBtn;
@synthesize financeBtn;
@synthesize maintenancerBtn;
@synthesize purchaseBtn;
@synthesize workOrderBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"SidebarView" owner:self options:nil];
                
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame sapDelegate : (AppDelegate *) sapDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSBundle mainBundle] loadNibNamed:@"SidebarView" owner:self options:nil];
        
        [self initializeData:sapDelegate];
        [self initializeViews:frame];
    }
    return self;
}


- (void) initializeViews : (CGRect) frame {
    
    self.sidebarView.frame = frame;
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"NavBg-1.png"]];
    self.sidebarView.backgroundColor = background;
    
    
    [self addSubview:self.sidebarView];
    
}

- (void) initializeData : (AppDelegate *) sapDelegate{

    _sapDelegate = sapDelegate;
}

- (void) setSiblingView : (UIView *) rootView
                 hrView : (UIView *) hrView {
    
    _rootView = rootView;
    _hrView = hrView;
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
    [self.workOrderBtn setImage:[UIImage imageNamed:@"WorkOrder.png"] forState:UIControlStateNormal];
    
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
    [self.workOrderBtn setImage:[UIImage imageNamed:@"WorkOrder.png"] forState:UIControlStateNormal];
    
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
    [self.workOrderBtn setImage:[UIImage imageNamed:@"WorkOrder.png"] forState:UIControlStateNormal];
    
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

-(IBAction)workOrderButtonPressed:(id)sender{
    
    for (UIView *subview in self.superview.subviews)
    {
        if([subview class] == [WorkOrderView class]){
            subview.hidden = NO;
        }else if([subview class] != [SidebarView class]){
            subview.hidden = YES;
        }
    }
    
    UIImage *image = [UIImage imageNamed:@"WorkOrderHover.png"];
    [sender setImage:image forState:UIControlStateNormal];
    
    [self.financeBtn setImage:[UIImage imageNamed:@"Finance.png"] forState:UIControlStateNormal];
    [self.hrBtn setImage:[UIImage imageNamed:@"Human.png"] forState:UIControlStateNormal];
    [self.purchaseBtn setImage:[UIImage imageNamed:@"purchasing.png"] forState:UIControlStateNormal];
}

-(IBAction) btnPressedResetData :(id)sender{
    
    if([_sapDelegate purgeAllObjects]){
        [_sapDelegate populateWithPrerequisiteData];
        
        if([_hrView respondsToSelector:@selector(resetDataInViews)]){
            [_hrView resetDataInViews];
        }
    }    
}


@end
