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
