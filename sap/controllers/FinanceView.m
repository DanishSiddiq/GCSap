//
//  FinanceView.m
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import "FinanceView.h"

@interface FinanceView()

@property (nonatomic, strong) AppDelegate *sapDelegate;

@property (retain, nonatomic) IBOutlet UIView* financeView;

@property (retain, nonatomic) IBOutlet UIView* titleView;

@property bool _isSlided;
@end

@implementation FinanceView

- (id)initWithFrame:(CGRect)frame sapDelegate : (AppDelegate *) sapDelegate;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"FinanceView" owner:self options:nil];
        
        
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"topBar.png"]];
        self.titleView.backgroundColor = background;
        
        self.financeView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.financeView];
        
        UILabel *lblName = (UILabel *)[self.titleView viewWithTag:10];
        lblName.text = NAME;
        
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

- (void) hideKeyBoard {
}


@end
