//
//  HRView.m
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import "HRView.h"

@interface HRView()

@property (retain, nonatomic) IBOutlet UIView* hrView;

- (IBAction)slideBtnPressed:(id)sender;

@end

@implementation HRView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"HRView" owner:self options:nil];
        
        self.hrView.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
        
        [self addSubview:self.hrView];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



- (IBAction)slideBtnPressed:(id)sender {
    CGRect splashTop = self.hrView.frame;
    splashTop.origin.x = -60;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.hrView.frame = splashTop;
    
    [UIView commitAnimations];
}
@end
