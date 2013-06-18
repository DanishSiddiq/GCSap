//
//  FinanceView.m
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import "FinanceView.h"

@interface FinanceView()
@property (retain, nonatomic) IBOutlet UIView* financeView;
@end

@implementation FinanceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"FinanceView" owner:self options:nil];
        
        self.financeView.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
        
        //NSLog(@"Sidebar View: %@", self.hrView);
        [self addSubview:self.financeView];
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

@end
