//
//  RootViewController.m
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import "RootViewController.h"
#import "SidebarView.h"
#import "HRView.h"
#import "FinanceView.h"
#import "MaintenanceView.h"
#import "PurchasesView.h"

@interface RootViewController ()

@property (nonatomic, strong) AppDelegate *sapDelegate;

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

    SidebarView* sidebarview = [[SidebarView alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 748.0)];
    [self.view addSubview:sidebarview];
    
    HRView* hrView = [[HRView alloc] initWithFrame:CGRectMake(120.0, 0.0, 1024, 748.0) sapDelegate:_sapDelegate];
    hrView.hidden = YES;
    [self.view addSubview:hrView];
    
    FinanceView* financeView = [[FinanceView alloc] initWithFrame:CGRectMake(120.0, 0.0, 1024, 748.0)];
    financeView.hidden = YES;
    [self.view addSubview:financeView];
    
    MaintenanceView* maintenanceView = [[MaintenanceView alloc] initWithFrame:CGRectMake(120.0, 0.0, 1024, 748.0)];
    maintenanceView.hidden = YES;
    [self.view addSubview:maintenanceView];
    
    PurchasesView* purchaseView = [[PurchasesView alloc] initWithFrame:CGRectMake(120.0, 0.0, 1024, 748.0)];    
    //purchaseView.bounds = CGRectMake(120.0, -10.0, 1024, 768);
    purchaseView.hidden = NO;
    [self.view addSubview:purchaseView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
