//
//  DashboardView.m
//  sap
//
//  Created by goodcore1 on 6/27/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import "DashboardView.h"

@interface DashboardView()


@property (retain, nonatomic) IBOutlet UIView* dashboardView;

-(IBAction)btnPressedPurchaseOrder:(id)sender;
-(IBAction)btnPressedFinance:(id)sender;
-(IBAction)btnPressedWorkOrder:(id)sender;
-(IBAction)btnPressedHrLeave:(id)sender;

@end

@implementation DashboardView

- (id)initWithFrame:(CGRect)frame sapDelegate : (AppDelegate *) sapDelegate;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSBundle mainBundle] loadNibNamed:@"DashboardView" owner:self options:nil];
        
        [self initializeViews:frame];
        
    }
    return self;
}

- (void) initializeViews : (CGRect) frame {
    
    self.dashboardView.frame = frame;
    
    [self addSubview:self.dashboardView];
    
}


-(IBAction)btnPressedPurchaseOrder:(id)sender{
    
    UIView *viewToShow, *viewToHide;
    
    
    for (UIView *subview in self.superview.subviews)
    {
        if([subview class] == [PurchasesView class]){
            
            viewToShow = subview;
        }
        else if([subview class] == [SidebarView class]){
            subview.hidden = NO;
            [(SidebarView *)subview selectButton:0];
        }
        else{
            if(![subview isHidden]){
                viewToHide = subview;
            }
        }
    }
    
    // hiding view
    [viewToShow setHidden:NO];
    [viewToHide setAlpha:1.0];
    [UIView animateWithDuration:1.0 animations:^{
        
        [viewToHide setAlpha:0.0];
        
    } completion:nil];

}

-(IBAction)btnPressedWorkOrder:(id)sender{
    
    UIView *viewToShow, *viewToHide;
    
    
    for (UIView *subview in self.superview.subviews)
    {
        if([subview class] == [WorkOrderView class]){
            
            viewToShow = subview;
        }
        else if([subview class] == [SidebarView class]){
            subview.hidden = NO;
            [(SidebarView *)subview selectButton:1];
        }
        else{
            if(![subview isHidden]){
                viewToHide = subview;
            }
        }
    }
    
    // hiding view
    [viewToShow setHidden:NO];
    [viewToHide setAlpha:1.0];
    [UIView animateWithDuration:1.0 animations:^{
        
        [viewToHide setAlpha:0.0];
        
    } completion:nil];
    
    
}

-(IBAction)btnPressedFinance:(id)sender{
    
    
    UIView *viewToShow, *viewToHide;
    
    
    for (UIView *subview in self.superview.subviews)
    {
        if([subview class] == [FinanceView class]){
            
            viewToShow = subview;
        }
        else if([subview class] == [SidebarView class]){
            subview.hidden = NO;
            [(SidebarView *)subview selectButton:2];
        }
        else{
            if(![subview isHidden]){
                viewToHide = subview;
            }
        }
    }
    
    // hiding view
    [viewToShow setHidden:NO];
    [viewToHide setAlpha:1.0];
    [UIView animateWithDuration:1.0 animations:^{
        
        [viewToHide setAlpha:0.0];
        
    } completion:nil];

}

-(IBAction)btnPressedHrLeave:(id)sender{
    
    UIView *viewToShow, *viewToHide;
    
    
    for (UIView *subview in self.superview.subviews)
    {
        if([subview class] == [HRView class]){
            
            viewToShow = subview;
        }
        else if([subview class] == [SidebarView class]){
            subview.hidden = NO;
            [(SidebarView *)subview selectButton:3];
        }
        else{
            if(![subview isHidden]){
                viewToHide = subview;
            }
        }
    }
    
    // hiding view
    [viewToShow setHidden:NO];
    [viewToHide setAlpha:1.0];
    [UIView animateWithDuration:1.0 animations:^{
        
        [viewToHide setAlpha:0.0];
        
    } completion:nil];
    
}


@end
