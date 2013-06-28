//
//  RootViewController.m
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@property (nonatomic, strong) AppDelegate *sapDelegate;
@property (nonatomic, strong) SidebarView *sidebarview;
@property (nonatomic, strong) HRView *hrView;
@property (nonatomic, strong) FinanceView *financeView;
@property (nonatomic, strong) WorkOrderView *workOrderView;
@property (nonatomic, strong) PurchasesView *purchaseView;
@property (nonatomic, strong) DashboardView *dashboardView;

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
//    self.view.frame = CGRectMake(0.0, 0.0, 1024.0, 768.0);
//    self.view.bounds = CGRectMake(0.0, 0.0, 1024.0, 768.0);
//    NSLog(@"Superview initial x position: %f", self.view.frame.origin.x);
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _sapDelegate = [[UIApplication sharedApplication] delegate];
    
    // initiating views
    [self initializeViews];
}

- (void) initializeViews {
    
    _sidebarview = [[SidebarView alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 748.0) sapDelegate:_sapDelegate];
    [self.view addSubview:_sidebarview];
    
    _hrView = [[HRView alloc] initWithFrame:CGRectMake(120.0, 0.0, 1024, 748.0) sapDelegate:_sapDelegate];
    [self.view addSubview:_hrView];
    
    _financeView = [[FinanceView alloc] initWithFrame:CGRectMake(120.0, 0.0, 1024, 748.0) sapDelegate:_sapDelegate];
    [self.view addSubview:_financeView];
    
    
    _workOrderView = [[WorkOrderView alloc] initWithFrame:CGRectMake(120.0, 0.0, 1024, 748.0) sapDelegate:_sapDelegate];
    [self.view addSubview:_workOrderView];
    
    _purchaseView = [[PurchasesView alloc] initWithFrame:CGRectMake(120.0, 0.0, 1024, 748.0) sapDelegate:_sapDelegate];
    [self.view addSubview:_purchaseView];
    
    _dashboardView = [[DashboardView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1004.0, 768.0) sapDelegate:_sapDelegate];
    [self.view addSubview:_dashboardView];
    
    
    [self showSplashScreen];
    [_sidebarview setSiblingView:self];
}

- (void) resetDataInViews{
    
    [SVProgressHUD showWithStatus:@"Resetting"];
    
    if([_sapDelegate purgeAllObjects]){
        [_sapDelegate populateWithPrerequisiteData];
        
        if([_hrView respondsToSelector:@selector(resetDataInViews)]){
            [_hrView resetDataInViews];
        }
        
        if([_purchaseView respondsToSelector:@selector(resetDataInViews)]){
            [_purchaseView resetDataInViews];
        }
        
        if([_workOrderView respondsToSelector:@selector(resetDataInViews)]){
            [_workOrderView resetDataInViews];
        }
        
        [SVProgressHUD showSuccessWithStatus:@"Data and View's reset successfully" duration:2.0f];        
    }
    else{
        
        [SVProgressHUD showErrorWithStatus:@"Data reset failed" duration:2.0f];
    }
    
}

- (void) hideKeyBoard {
    [_hrView hideKeyBoard];
    [_financeView hideKeyBoard];
    [_purchaseView hideKeyBoard];
    [_workOrderView hideKeyBoard];    
}

- (void) showSplashScreen {
    
    _sidebarview.hidden     = YES;
    _hrView.hidden          = YES;
    _financeView.hidden     = YES;
    _workOrderView.hidden   = YES;
    _purchaseView.hidden    = YES;
    [_dashboardView setAlpha:1.0];
    _dashboardView.hidden   = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
