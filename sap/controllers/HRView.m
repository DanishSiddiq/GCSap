//
//  HRView.m
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import "HRView.h"

@interface HRView()

@property (nonatomic, strong) AppDelegate *sapDelegate;
@property (retain, nonatomic) IBOutlet UIView* titleView;
@property (retain, nonatomic) IBOutlet UIView *hrView;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UIButton *btnLeaveRequest;
@property (retain, nonatomic) IBOutlet UIButton *btnLeaveApproval;
@property (retain, nonatomic) HRLeaveApprovalView* hrleaveApproval;
@property (retain, nonatomic) HRLeaveRequestView* hrleaveRequest;

@end

@implementation HRView

- (id)initWithFrame:(CGRect)frame sapDelegate : (AppDelegate *) sapDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"HRView" owner:self options:nil];
        [self initializeData:sapDelegate];
        [self initializeViews:frame];
        
    }
    return self;
}


- (void) initializeViews : (CGRect) frame {
    
    
    self.hrView.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
    [self addSubview:self.hrView];
    
    _hrleaveApproval = [[HRLeaveApprovalView alloc] initWithFrame:CGRectMake(0.0f, 50.0f, 1024.0f, 718) sapDelegate:_sapDelegate];
    [self addSubview:_hrleaveApproval];
    
    _hrleaveRequest = [[HRLeaveRequestView alloc] initWithFrame:CGRectMake(0.0f, 50.0f, 1024.0f, 718) sapDelegate:_sapDelegate];
    [self addSubview:_hrleaveRequest];
    [_hrleaveRequest setHidden:YES];
    
    // leave request will be shown for toggling
    [_btnLeaveApproval setHidden:YES];
    
    // setting background title view color
    self.titleView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"topBar.png"]];
    
    UILabel *lblName = (UILabel *)[self.titleView viewWithTag:10];
    lblName.text = NAME;
    
}

-(void) initializeData  : (AppDelegate *) sapDelegate{
    
    _sapDelegate = sapDelegate;
}

- (void) resetDataInViews{
    
    [_hrleaveApproval fetchHRLeavesFromCoreData];
    [_hrleaveApproval filterLeaves];
    [_hrleaveApproval updateViews];
    
    [_hrleaveRequest fetchHRLeavesFromCoreData];
    [_hrleaveRequest filterLeaves];
    [_hrleaveRequest updateViews];
}

// selectors
- (IBAction)btnPressedSlide:(id)sender {
 
    // hide keyboard
    [self endEditing:YES];
    
    if(self.frame.origin.x == 120){
        
        CGRect toFrame = self.frame;
        toFrame.origin.x = 0.0;
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = toFrame;
        } completion:nil];
    }
    else{
        
        CGRect toFrame = self.frame;
        toFrame.origin.x = 120;
        
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = toFrame;
        } completion:nil];
    }
}

- (IBAction)btnPressedLeaveRequest:(id)sender {
    
    // hide keyboard
    [self endEditing:YES];
    
    [_lblTitle setText:@"LEAVE REQUEST (EMPLOYEE SECTION)"];
    
    [UIView transitionWithView:self duration:1.0 options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        [_hrleaveRequest setHidden:NO];
                        [_hrleaveApproval setHidden:YES];
                        
                        [_btnLeaveRequest setHidden:YES];
                        [_btnLeaveApproval setHidden:NO];
                        
                    } completion:^(BOOL finished) {
                        if(finished){
                        }
                    }];
    
}

- (IBAction)btnPressedLeaveApproval:(id)sender {
    
    // hide keyboard
    [self endEditing:YES];
    
    [_lblTitle setText:@"LEAVE APPROVAL (MANAGERIAL SECTION)"];
    
    [UIView transitionWithView:self duration:1.0 options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{
                        [_hrleaveRequest setHidden:YES];
                        [_hrleaveApproval setHidden:NO];
                        
                        [_btnLeaveRequest setHidden:NO];
                        [_btnLeaveApproval setHidden:YES];
                        
                    } completion:^(BOOL finished) {
                        if(finished){
                        }
                    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
    [_hrleaveRequest setSearchBarCancelButtonStyle];
    [super touchesBegan:touches withEvent:event];
}

@end
