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
@property (retain, nonatomic) NSIndexPath* selectedIndexPath;
@property (retain, nonatomic) IBOutlet UITableView *tblPurchases;

@property (retain, nonatomic) IBOutlet UIView* purchaseViewDetailUpper;

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
        
        [_tblPurchases setShowsVerticalScrollIndicator:NO];
        
        self._isSlided = NO;
        [self initializeData:sapDelegate];
        
    }
    return self;
}

-(void) initializeData  : (AppDelegate *) sapDelegate{
    
    _sapDelegate = sapDelegate;
    _lstPurchases = [[NSMutableArray alloc] init];
    _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
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

// you have to update the view also have to change the side vise fileds accordingly
-(void) updateViews {
    
    [_tblPurchases reloadData];
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
    UIImageView *imgViewBackground;
    
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
    imgViewBackground = (UIImageView *)[cell.contentView viewWithTag:10];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(_selectedIndexPath.row == indexPath.row){
        
        [cell setFrame:CGRectMake(0, 0, 292, 120)];
        [imgViewBackground setFrame:CGRectMake(0, 0, 292, 120)];
        [imgViewBackground setImage:[UIImage imageNamed:@"DataBoxHover"]];
        [lblPOId setTextColor:[UIColor whiteColor]];
        [lblVendor setTextColor:[UIColor whiteColor]];
        [lblAmount setTextColor:[UIColor whiteColor]];
        [lblPODate setTextColor:[UIColor whiteColor]];
        [lblOrderType setTextColor:[UIColor whiteColor]];
        [lblCurrency setTextColor:[UIColor whiteColor]];
    }
    else{
        [cell setFrame:CGRectMake(0, 0, 292, 120)];
        [imgViewBackground setFrame:CGRectMake(0, 0, 292, 120)];
        [imgViewBackground setImage:[UIImage imageNamed:@"DataBox"]];
        [lblPOId setTextColor:[UIColor blackColor]];
        [lblVendor setTextColor:[UIColor blackColor]];
        [lblAmount setTextColor:[UIColor blackColor]];
        [lblPODate setTextColor:[UIColor blackColor]];
        [lblOrderType setTextColor:[UIColor blackColor]];
        [lblCurrency setTextColor:[UIColor blackColor]];
    }
    
    
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
    _selectedIndexPath = indexPath;
    [_tblPurchases reloadData];
    
    //NSLog(@"Index: %@", _selectedIndexPath);
}


@end
