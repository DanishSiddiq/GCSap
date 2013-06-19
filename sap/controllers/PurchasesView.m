//
//  PurchasesView.m
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import "PurchasesView.h"

@interface PurchasesView()

@property (retain, nonatomic) IBOutlet UIView* purchaseView;

@property (retain, nonatomic) IBOutlet UIView* purchseItemView;
@property (strong, nonatomic) IBOutlet UITableView* purchseItemTable;
@property (strong, nonatomic) IBOutlet UITableViewCell* purchseItemTableCell;
@property (strong, nonatomic) IBOutlet UILabel* idLabel;
@property (strong, nonatomic) IBOutlet UILabel* vendorLabel;
@property (strong, nonatomic) IBOutlet UILabel* amountLabel;
@property (strong, nonatomic) IBOutlet UILabel* dateLabel;
@property (strong, nonatomic) IBOutlet UILabel* currencyLabel;
@property (strong, nonatomic) IBOutlet UILabel* orderTypeLabel;

@property (retain, nonatomic) IBOutlet UIView* purchseItemDetailView;

@property bool _isSlided;



@end

@implementation PurchasesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [[NSBundle mainBundle] loadNibNamed:@"PurchasesView" owner:self options:nil];
        
        self.purchaseView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.purchaseView];
        self._isSlided = NO;
        
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
