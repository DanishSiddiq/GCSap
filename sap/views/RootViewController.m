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
}

- (void) viewWillAppear:(BOOL)animated{

    _sidebarview = [[SidebarView alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 748.0) sapDelegate:_sapDelegate];
    [self.view addSubview:_sidebarview];
    
    _hrView = [[HRView alloc] initWithFrame:CGRectMake(120.0, 0.0, 1024, 748.0) sapDelegate:_sapDelegate];
    _hrView.hidden = YES;
    [self.view addSubview:_hrView];
    
    _financeView = [[FinanceView alloc] initWithFrame:CGRectMake(120.0, 0.0, 1024, 748.0) sapDelegate:_sapDelegate];
    _financeView.hidden = YES;
    [self.view addSubview:_financeView];
    
//    MaintenanceView* maintenanceView = [[MaintenanceView alloc] initWithFrame:CGRectMake(120.0, 0.0, 1024, 748.0)];
//    maintenanceView.hidden = YES;
//    [self.view addSubview:maintenanceView];
    
    _workOrderView = [[WorkOrderView alloc] initWithFrame:CGRectMake(120.0, 0.0, 1024, 748.0) sapDelegate:_sapDelegate];
    _workOrderView.hidden = YES;
    [self.view addSubview:_workOrderView];
    
    _purchaseView = [[PurchasesView alloc] initWithFrame:CGRectMake(120.0, 0.0, 1024, 748.0) sapDelegate:_sapDelegate];
    _purchaseView.hidden = NO;
    [self.view addSubview:_purchaseView];
    
    [_sidebarview setSiblingView:self];
}


- (void) resetDataInViews{
    
    [SVProgressHUD showWithStatus:@"Reseting"];
    
    if([_sapDelegate purgeAllObjects]){
        [_sapDelegate populateWithPrerequisiteData];
        
        if([_hrView respondsToSelector:@selector(resetDataInViews)]){
            [_hrView resetDataInViews];
        }
        
        [SVProgressHUD showSuccessWithStatus:@"Data and View's reset successfully" duration:2.0f];        
    }
    else{
        
        [SVProgressHUD showErrorWithStatus:@"Data reset failed" duration:2.0f];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
