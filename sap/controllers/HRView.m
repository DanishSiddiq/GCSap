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
@property (retain, nonatomic) IBOutlet UIView *hrView;

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
        
    HRLeaveRequestView* hrleaveRequest = [[HRLeaveRequestView alloc] initWithFrame:CGRectMake(0.0f, 50.0f, 1024.0f, 718) sapDelegate:_sapDelegate];
    [self addSubview:hrleaveRequest];
    [hrleaveRequest setHidden:YES];
    
    HRLeaveApprovalView* hrleaveApproval = [[HRLeaveApprovalView alloc] initWithFrame:CGRectMake(0.0f, 50.0f, 1024.0f, 718) sapDelegate:_sapDelegate];
    [self addSubview:hrleaveApproval];
    //[hrleaveApproval setHidden:YES];
}

-(void) initializeData  : (AppDelegate *) sapDelegate{
    
    _sapDelegate = sapDelegate;
}

// selectors
- (IBAction)slideBtnPressed:(id)sender {
 
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

@end
