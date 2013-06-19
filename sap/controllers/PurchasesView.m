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
@property (nonatomic, strong) AppDelegate *sapDelegate;
@property (retain, nonatomic) NSMutableArray* lstPurchases;
@property (retain, nonatomic) IBOutlet UIView* titleView;

@property bool _isSlided;

@end

@implementation PurchasesView

- (id)initWithFrame:(CGRect)frame sapDelegate:(AppDelegate *)sapDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [[NSBundle mainBundle] loadNibNamed:@"PurchasesView" owner:self options:nil];
        
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"topBar.png"]];
        self.titleView.backgroundColor = background;
        
        self.purchaseView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.purchaseView];
        self._isSlided = NO;
        [self initializeData:sapDelegate];
        
    }
    return self;
}

-(void) initializeData  : (AppDelegate *) sapDelegate{
    
    _sapDelegate = sapDelegate;
    _lstPurchases = [[NSMutableArray alloc] init];
    
    // data base calling for fetching data
    [self fetchDataFromServer];
}

- (void) fetchDataFromServer {
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Purchase_Orders"
                                              inManagedObjectContext:_sapDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    [_lstPurchases addObjectsFromArray:[_sapDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
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

#pragma table delegates
#pragma purchase order delegates

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_lstPurchases count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f;
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *branchCellIdentifier = [NSString stringWithFormat:@"PurchaseViewCell"];
    UITableViewCell *cell;
    UILabel *lblPOId, *lblPODate, *lblVendor, *lblCurrency, *lblAmount, *lblOrderType;
    
    cell = [tableView dequeueReusableCellWithIdentifier:branchCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil] objectAtIndex:0];
        
    }
    
    lblPOId = (UILabel *)[cell.contentView viewWithTag:1];
    lblVendor = (UILabel *)[cell.contentView viewWithTag:2];
    lblAmount = (UILabel *)[cell.contentView viewWithTag:3];
    lblPODate = (UILabel *)[cell.contentView viewWithTag:4];
    lblOrderType = (UILabel *)[cell.contentView viewWithTag:5];
    lblCurrency = (UILabel *)[cell.contentView viewWithTag:6];
    
    
    Purchase_Orders *purchaseObj = [_lstPurchases objectAtIndex:indexPath.row];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    
    lblPOId.text = [NSString stringWithFormat:@"%@", purchaseObj.po_id];
    lblPODate.text = [format stringFromDate:purchaseObj.po_date];
    lblVendor.text = purchaseObj.vendor;
    lblOrderType.text = purchaseObj.order_type;
    lblAmount.text = [NSString stringWithFormat:@"%@", purchaseObj.amount];
    lblCurrency.text = purchaseObj.currency;
    
    return cell;

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
