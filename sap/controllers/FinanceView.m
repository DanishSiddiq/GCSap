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
    if(!self._isSlided){
        self._isSlided = YES;
        CGRect splashTop = self.frame;
        splashTop.origin.x = 0.0;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        self.frame = splashTop;
        
        [UIView commitAnimations];
        
    }else{
        self._isSlided = NO;
        CGRect splashTop = self.frame;
        splashTop.origin.x = 120;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        self.frame = splashTop;
        
        [UIView commitAnimations];
    }
    
}


@end
