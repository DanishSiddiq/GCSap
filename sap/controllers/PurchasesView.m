//
//  PurchasesView.m
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import "PurchasesView.h"

@interface PurchasesView()

@property (strong, nonatomic) IBOutlet UIView* purchaseView;
@property (nonatomic, strong) AppDelegate *sapDelegate;
@property (retain, nonatomic) NSMutableArray* lstPurchases;
@property (retain, nonatomic) NSMutableArray *lstFilterPurchases;
@property (weak, nonatomic) NSMutableString *filterText;
@property (retain, nonatomic) IBOutlet UIView* titleView;
@property (strong, nonatomic) IBOutlet UITableView *tblPurchases;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) BOOL isApprovedSelected;
@property (nonatomic) BOOL isDeclined;
@property (nonatomic) BOOL isPending;

@property (strong, nonatomic) NSNumber *selectedId;
@property (retain, nonatomic) NSIndexPath* selectedIndexPath;

@property (strong, nonatomic) Purchase_Orders *currentPO;

@property (retain, nonatomic) IBOutlet UIView *vwStatusPanel;
@property (retain, nonatomic) IBOutlet UILabel *lblStatusPanel;

// PO Detail Objects
@property (strong, nonatomic) IBOutlet UIView *vwPurchaseDetail;
@property (strong, nonatomic) IBOutlet UITableView *tblPoItems;
@property (retain, nonatomic) NSMutableArray* lstPoItems;
@property (strong, nonatomic) IBOutlet UIView * tblHeaderPoItems;

@property (strong, nonatomic) IBOutlet UITableView *tblPoInvoices;
@property (retain, nonatomic) NSMutableArray* lstPoInvoices;
@property (strong, nonatomic) IBOutlet UIView * tblHeaderPoInvoices;

@property (strong, nonatomic) IBOutlet UITableView *tblPoDelivery;
@property (retain, nonatomic) NSMutableArray* lstPoDelivery;
@property (strong, nonatomic) IBOutlet UIView * tblHeaderPoDelivery;

@property (strong, nonatomic) IBOutlet UIView* purchaseViewDetailUpper;
@property (strong, nonatomic) IBOutlet UIButton * poItemsButton;
@property (strong, nonatomic) IBOutlet UIButton * poInvoiceButton;
@property (strong, nonatomic) IBOutlet UIButton * poDeliveryButton;

- (IBAction)poDetailsBtnPressed:(id)sender;

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
        [_tblPoItems setShowsVerticalScrollIndicator:NO];
        [_tblPoInvoices setShowsVerticalScrollIndicator:NO];
        [_tblPoDelivery setShowsVerticalScrollIndicator:NO];
        
        [_vwStatusPanel.layer setCornerRadius:3.0f];
        [_vwStatusPanel setHidden:YES];
        
        _tblPoDelivery.hidden = _tblPoInvoices.hidden = YES;
        
        UILabel *lblName = (UILabel *)[self.titleView viewWithTag:10];
        lblName.text = NAME;
        
        self._isSlided = self.poItemsButton.userInteractionEnabled = NO;
        [self initializeData:sapDelegate];
        
    }
    return self;
}

-(void) initializeData  : (AppDelegate *) sapDelegate{
    
    _sapDelegate = sapDelegate;
    _lstPurchases = [[NSMutableArray alloc] init];
    _lstPoItems = [[NSMutableArray alloc] init];
    _lstPoInvoices = [[NSMutableArray alloc] init];
    _lstPoDelivery = [[NSMutableArray alloc] init];
    _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _lstFilterPurchases = [[NSMutableArray alloc] init];
    _filterText = [NSMutableString stringWithFormat:@""];
    _selectedId = nil;
    
    _isApprovedSelected = _isDeclined = _isPending = YES;
    
    // data base calling for fetching data
    [_lstPurchases removeAllObjects];
    _lstPurchases = [self fetchDataFromServerWithPredicate:nil AndEntityName:@"Purchase_Orders"];
    
    [self filterPurchases];
    [_tblPurchases reloadData];
    
    Purchase_Orders * poFirst = [_lstFilterPurchases objectAtIndex:_selectedIndexPath.row];
    self.currentPO = poFirst;
    [self getPurchaseOrderDetails: poFirst.po_id];
}

- (void) showPanelBarWithMessage : (BOOL) isSuccess msg : (NSString *) msg {
    
    if(isSuccess){
        [_vwStatusPanel setBackgroundColor:[UIColor colorWithRed:223/255.f green:240/255.f blue:216/255.f alpha:1.0]];
        [_vwStatusPanel.layer setBorderColor:[UIColor colorWithRed:70/255.f green:149/255.f blue:105/255.f alpha:1.0].CGColor];
        [_vwStatusPanel.layer setBorderWidth:1.0];
        
        [_lblStatusPanel setTextColor:[UIColor colorWithRed:70/255.f green:149/255.f blue:105/255.f alpha:1.0]];
    }
    else{
        
        [_vwStatusPanel setBackgroundColor:[UIColor colorWithRed:255/255.f green:192/255.f blue:192/255.f alpha:1.0]];
        [_vwStatusPanel.layer setBorderColor:[UIColor colorWithRed:185/255.f green:74/255.f blue:72/255.f alpha:1.0].CGColor];
        [_vwStatusPanel.layer setBorderWidth:1.0];
        
        [_lblStatusPanel setTextColor:[UIColor colorWithRed:185/255.f green:74/255.f blue:72/255.f alpha:1.0]];
    }
    
    [_lblStatusPanel setText:msg];
    [_vwStatusPanel setAlpha:0.0];
    [_vwStatusPanel setHidden:NO];
    
    [UIView animateWithDuration:1.0 animations:^{
        [_vwStatusPanel setAlpha:1.0];
        
    } completion:^(BOOL finished) {
        
        // now hide it again after 2 sec
        [UIView animateWithDuration:2.5 animations:^{
            [_vwStatusPanel setAlpha:0.1];
            
        } completion:^(BOOL finished) {
            [_vwStatusPanel setHidden:YES];
        }];
    }];
}


-(void) resetDataInViews{
    _lstPurchases = [self fetchDataFromServerWithPredicate:nil AndEntityName:@"Purchase_Orders"];
    [self filterPurchases];
    [_tblPurchases reloadData];
    Purchase_Orders * poFirst = [_lstFilterPurchases objectAtIndex:_selectedIndexPath.row];
    [self getPurchaseOrderDetails: poFirst.po_id];
}

- (NSMutableArray *) fetchDataFromServerWithPredicate: (NSPredicate *) predicate AndEntityName:(NSString *) entityName {
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:_sapDelegate.managedObjectContext];
    NSMutableArray * arrayObjects = [[NSMutableArray alloc] init];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [arrayObjects addObjectsFromArray:[_sapDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    return arrayObjects;
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

// selectors
- (IBAction)btnPressedApproved:(id)sender {
    
    _isApprovedSelected = !_isApprovedSelected;
    [(UIButton *)sender setImage:[UIImage imageNamed:_isApprovedSelected ? @"checkGreenHover" : @"checkGreen"] forState:UIControlStateNormal];
    
    [self filterPurchases];
    [self updateViews];
    
}

- (IBAction)btnPressedDeclined:(id)sender {
    
    _isDeclined = !_isDeclined;
    [(UIButton *)sender setImage:[UIImage imageNamed:_isDeclined ? @"checkRedHover" : @"checkRed"] forState:UIControlStateNormal];
    
    [self filterPurchases];
    [self updateViews ];
    
}

- (IBAction)btnPressedPending:(id)sender {
    
    _isPending = !_isPending;
    [(UIButton *)sender setImage:[UIImage imageNamed:_isPending ? @"checkYellowHover" : @"checkYellow"] forState:UIControlStateNormal];
    
    [self filterPurchases];
    [self updateViews ];
    
}

- (IBAction)btnPoApprovedPressed:(id)sender {
    if(_selectedIndexPath && _selectedIndexPath.row >= 0){
        
        NSError *error;
        Purchase_Orders *poObj;
        
        @try {
            
            poObj =  [_lstFilterPurchases objectAtIndex:_selectedIndexPath.row];
            [poObj setApproved:[NSNumber numberWithBool:YES]];
            [_sapDelegate.managedObjectContext save:&error];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", error);
        }
        @finally {
            
            if(!error){
                
                if(_isApprovedSelected){
                    
                    [self showPanelBarWithMessage:YES msg:@"Request has been approved successfully"];
                    [_tblPurchases reloadRowsAtIndexPaths: [NSArray arrayWithObject:_selectedIndexPath]
                                     withRowAnimation:UITableViewRowAnimationLeft];
                }
                else{
                    
                    [self showPanelBarWithMessage:YES msg:@"Request has been approved successfully and moved into Approved panel"];
                    
                    [UIView transitionWithView:_vwPurchaseDetail
                                      duration:1.0
                                       options:UIViewAnimationOptionTransitionCurlDown
                                    animations:nil
                                    completion:nil];
                }
                
                [self filterPurchases];
                [self updateViews ];
            }
            else{
                
                [self showPanelBarWithMessage:NO msg:@"Request approve failed"];
            }
        }
    }

    
}

- (IBAction)btnPoDeclinedPressed:(id)sender {
    
    if(_selectedIndexPath && _selectedIndexPath.row >= 0){
        
        NSError *error;
        Purchase_Orders *poObj;
        
        @try {
            
            poObj =  [_lstFilterPurchases objectAtIndex:_selectedIndexPath.row];
            [poObj setDeclined:[NSNumber numberWithBool:YES]];
            [_sapDelegate.managedObjectContext save:&error];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", error);
        }
        @finally {
            
            if(!error){
                
                if(_isDeclined){
                    
                    [self showPanelBarWithMessage:YES msg:@"Request has been declined successfully"];
                    [_tblPurchases reloadRowsAtIndexPaths: [NSArray arrayWithObject:_selectedIndexPath]
                                     withRowAnimation:UITableViewRowAnimationLeft];
                }
                else{
                    
                    [self showPanelBarWithMessage:YES msg:@"Request has been declined successfully and moved into Declined panel"];
                    
                    [UIView transitionWithView:_vwPurchaseDetail
                                      duration:1.0
                                       options:UIViewAnimationOptionTransitionCurlDown
                                    animations:nil
                                    completion:nil];
                }
                
                [self filterPurchases];
                [self updateViews ];
            }
            else{
                
                [self showPanelBarWithMessage:NO msg:@"Request decline failed"];
            }
        }
    }

    
}



#pragma searchbar delegates

-(void) setKeyBoardForSearchBar{
    
    for (UIView *searchBarSubview in [_searchBar subviews]) {
        
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
            
            @try {
                
                [(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDone];
                [(UITextField *)searchBarSubview setKeyboardAppearance:UIKeyboardAppearanceAlert];
            }
            @catch (NSException * e) {
                
                // ignore exception
            }
        }
    }
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    // changing text logic here
    [_filterText setString:searchText];
    [self filterPurchases];
    [self updateViews];
    
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    // search logic will go here
    [searchBar resignFirstResponder];
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar setText:@""];
    [searchBar resignFirstResponder];
    [_filterText setString:searchBar.text];
    [self filterPurchases];
    [self updateViews];
    
}

- (void) filterPurchases {
    
    [_lstFilterPurchases removeAllObjects];
    [_filterText setString:[_filterText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    _selectedIndexPath = nil;
    
    if([_filterText length] > 0){
        
        for(Purchase_Orders *purchase in _lstPurchases){
            
            // case when both checkboxes are selected
            if(_isApprovedSelected && _isDeclined && [[[purchase vendor] lowercaseString] rangeOfString:[_filterText lowercaseString]].location != NSNotFound){
                
                [_lstFilterPurchases addObject:purchase];
            }
            // case when any one checkbox is selected
            else if(_isDeclined || _isApprovedSelected){
                if(_isApprovedSelected && [[purchase approved] isEqualToNumber:[NSNumber numberWithBool:YES]]
                    &&  [[[purchase vendor] lowercaseString] rangeOfString:[_filterText lowercaseString]].location != NSNotFound){
                    
                    [_lstFilterPurchases addObject:purchase];
                
                }
                
                if(_isDeclined && [[purchase declined] isEqualToNumber:[NSNumber numberWithBool:YES]]
                   &&  [[[purchase vendor] lowercaseString] rangeOfString:[_filterText lowercaseString]].location != NSNotFound){
                    
                    [_lstFilterPurchases addObject:purchase];
                    
                }
            }
            
            if(_isPending && [[purchase approved] isEqualToNumber:[NSNumber numberWithBool:NO]] &&
               [[purchase declined] isEqualToNumber:[NSNumber numberWithBool:NO]] &&
               [[[purchase vendor] lowercaseString] rangeOfString:[_filterText lowercaseString]].location != NSNotFound){
                [_lstFilterPurchases addObject:purchase];
            }
        }
    }
    
    else{
        
        for(Purchase_Orders *purchase in _lstPurchases){
            
            // case when both checkboxes are selected
            if(_isApprovedSelected && [[purchase approved] isEqualToNumber:[NSNumber numberWithBool:YES]] && _isDeclined && [[purchase declined] isEqualToNumber:[NSNumber numberWithBool:YES]]){
                
                [_lstFilterPurchases addObject:purchase];
            }
             // case when any one checkbox is selected
            else if(_isDeclined || _isApprovedSelected){
                
                if(_isApprovedSelected && [[purchase approved] isEqualToNumber:[NSNumber numberWithBool:YES]]){
                    [_lstFilterPurchases addObject:purchase];
                }
                
                if(_isDeclined && [[purchase declined] isEqualToNumber:[NSNumber numberWithBool:YES]]){
                    [_lstFilterPurchases addObject:purchase];
                }
            }

            if(_isPending && [[purchase approved] isEqualToNumber:[NSNumber numberWithBool:NO]] &&
               [[purchase declined] isEqualToNumber:[NSNumber numberWithBool:NO]]){
                [_lstFilterPurchases addObject:purchase];
            }
        }
    }
    
    [self updateSelectedIndexPath];
}

- (void) updateSelectedIndexPath {
    
    if(_lstFilterPurchases.count > 0){
        
        NSInteger index;
        BOOL isExist = NO;
        
        if(_selectedId){
            
            for(index = 0; index < [_lstFilterPurchases count]; index++){
                
                Purchase_Orders *obj = [_lstFilterPurchases objectAtIndex:index];                
                if([obj.po_id isEqualToNumber:_selectedId]){
                    isExist = YES;
                    break;
                }
            }
        }
        _selectedIndexPath = [NSIndexPath indexPathForRow:isExist ? index : 0 inSection:0];
    }
}

// you have to update the view also have to change the side vise fileds accordingly
-(void) updateViews {
    
    [_tblPurchases reloadData];
    [self setPODetailIndexAfterFilter];
    [_tblPurchases scrollToRowAtIndexPath:_selectedIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma table delegates
#pragma purchase order delegates

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.tblPurchases){
        return [_lstFilterPurchases count];
    }
    else if(tableView == self.tblPoItems) {
        return [_lstPoItems count];
    }
    else if(tableView == self.tblPoInvoices) {
        return [_lstPoInvoices count];
    }
    else{
        return [_lstPoDelivery count];
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.tblPurchases){
        
        return 130.0f;
        
    }else {
        return 40.0f;
    }
    
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView == self.tblPurchases){
    
        return 1.0f;
    }
    else{
     
        return 30.0f;
    }
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f;
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(tableView == self.tblPoItems){
        
        return self.tblHeaderPoItems;
    }
    else if(tableView == self.tblPoDelivery){
        
        return self.tblHeaderPoDelivery;
        
    }
    else if(tableView == self.tblPoInvoices){
        
        return self.tblHeaderPoInvoices;
        
    }
    else{
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == self.tblPurchases){
        
        return [self initializePurchaseTable:tableView cellForRowAtIndexPath:indexPath];
        
    }
    else if(tableView == self.tblPoItems) {
        
        return [self initializePoItemsTable:tableView cellForRowAtIndexPath:indexPath];
        
    }
    else if(tableView == self.tblPoDelivery) {
        
        return [self initializePoDeliveryTable:tableView cellForRowAtIndexPath:indexPath];
        
    }
    else{
        
        return [self initializePoInvoicesTable:tableView cellForRowAtIndexPath:indexPath];
        
    }
    
}

-(UITableViewCell *) initializePurchaseTable:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *branchCellIdentifier = [NSString stringWithFormat:@"PurchaseViewCell"];
    UITableViewCell *cell;
    UILabel *lblPOId, *lblPODate, *lblVendor, *lblCurrency, *lblAmount, *lblOrderType;
    UIImageView *imgViewBackground, *imgViewStatus;
    
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
    imgViewBackground = (UIImageView *)[cell.contentView viewWithTag:7];
    imgViewStatus = (UIImageView *)[cell.contentView viewWithTag:8];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(_selectedIndexPath && _selectedIndexPath.row == indexPath.row){
        
        [cell setFrame:CGRectMake(0, 0, 292, 125)];
        [imgViewBackground setFrame:CGRectMake(10, 0, 282, 125)];
        [imgViewBackground setImage:[UIImage imageNamed:@"DataBoxHover"]];
        [lblPOId setTextColor:[UIColor whiteColor]];
        [lblVendor setTextColor:[UIColor whiteColor]];
        [lblAmount setTextColor:[UIColor whiteColor]];
        [lblPODate setTextColor:[UIColor whiteColor]];
        [lblOrderType setTextColor:[UIColor whiteColor]];
        [lblCurrency setTextColor:[UIColor whiteColor]];
    }
    else{
        [cell setFrame:CGRectMake(0, 0, 292, 125)];
        [imgViewBackground setFrame:CGRectMake(10, 0, 282, 125)];
        [imgViewBackground setImage:[UIImage imageNamed:@"DataBox"]];
        [lblPOId setTextColor:[UIColor blackColor]];
        [lblVendor setTextColor:[UIColor blackColor]];
        [lblAmount setTextColor:[UIColor blackColor]];
        [lblPODate setTextColor:[UIColor blackColor]];
        [lblOrderType setTextColor:[UIColor blackColor]];
        [lblCurrency setTextColor:[UIColor blackColor]];
    }
    
    
    Purchase_Orders *purchaseObj = [_lstFilterPurchases objectAtIndex:indexPath.row];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    
    lblPOId.text = [NSString stringWithFormat:@"%@", purchaseObj.po_id];
    lblPODate.text = [format stringFromDate:purchaseObj.po_date];
    lblVendor.text = purchaseObj.vendor;
    lblOrderType.text = purchaseObj.order_type;
    lblAmount.text = [NSString stringWithFormat:@"%@", purchaseObj.amount];
    lblCurrency.text = purchaseObj.currency;
    
    if([purchaseObj.approved isEqualToNumber:[NSNumber numberWithBool:NO]] &&
       [purchaseObj.declined isEqualToNumber:[NSNumber numberWithBool:NO]]){
        
        [imgViewStatus setImage:[UIImage imageNamed:@"orangeCircle"]];
        
    }else if([purchaseObj.approved isEqualToNumber:[NSNumber numberWithBool:YES]]){
        
        [imgViewStatus setImage:[UIImage imageNamed:@"greenCircle"]];
        
    }else{
        [imgViewStatus setImage:[UIImage imageNamed:@"redCircle"]];
    }
    
    return cell;
}

-(void) setPODetailIndexAfterFilter{
    if(_selectedIndexPath != nil){
        Purchase_Orders * poFirst = [_lstFilterPurchases objectAtIndex:_selectedIndexPath.row];
        [self getPurchaseOrderDetails: poFirst.po_id];
    }else{
        [self getPurchaseOrderDetails: 0];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tblPurchases reloadData];
    Purchase_Orders * poObj = [_lstFilterPurchases objectAtIndex:indexPath.row];
    self.currentPO = poObj;
    _selectedIndexPath = indexPath;
    _selectedId = poObj.po_id;
    [self updateViews];
}

-(void) getPurchaseOrderDetails: (NSNumber*) poID{
    [_tblPoInvoices setHidden:YES];
    [_tblPoItems setHidden:NO];
    [_tblPoDelivery setHidden:YES];
    [_poItemsButton setUserInteractionEnabled:NO];
    [_poInvoiceButton setUserInteractionEnabled:YES];
    [_poDeliveryButton setUserInteractionEnabled:YES];
    _btnApproved.hidden = _btnDeclined.hidden = YES;
    _poDeliveryButton.alpha = _poInvoiceButton.alpha = 0.7f;
    _poItemsButton.alpha = 1.0f;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(po_id = %@)", poID];
    _lstPoInvoices = [self fetchDataFromServerWithPredicate:predicate AndEntityName:@"PO_Invoice"];
    _lstPoItems = [self fetchDataFromServerWithPredicate:predicate AndEntityName:@"PO_Items"];
    _lstPoDelivery = [self fetchDataFromServerWithPredicate:predicate AndEntityName:@"PO_Delivery"];
    
    UILabel *lblPOId, *lblPODate, *lblVendor, *lblCurrency, *lblAmount, *lblOrderType, *lblMainVendor, *lblLocation;
    UIImageView *imgViewVendor;
    
    lblMainVendor = (UILabel *)[self.purchaseViewDetailUpper viewWithTag:10];
    lblPOId = (UILabel *)[self.purchaseViewDetailUpper viewWithTag:11];
    lblVendor = (UILabel *)[self.purchaseViewDetailUpper viewWithTag:12];
    lblAmount = (UILabel *)[self.purchaseViewDetailUpper viewWithTag:13];
    lblPODate = (UILabel *)[self.purchaseViewDetailUpper viewWithTag:14];
    lblOrderType = (UILabel *)[self.purchaseViewDetailUpper viewWithTag:15];
    lblCurrency = (UILabel *)[self.purchaseViewDetailUpper viewWithTag:16];
    lblLocation = (UILabel *)[self.purchaseViewDetailUpper viewWithTag:20];
    imgViewVendor = (UIImageView *)[self.purchaseViewDetailUpper viewWithTag:30];
    
    if(_lstFilterPurchases.count > 0){
        Purchase_Orders *purchaseObj = [_lstFilterPurchases objectAtIndex:_selectedIndexPath.row];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateStyle:NSDateFormatterMediumStyle];
        
        lblPOId.text = [NSString stringWithFormat:@"%@", purchaseObj.po_id];
        lblPODate.text = [format stringFromDate:purchaseObj.po_date];
        lblVendor.text = lblMainVendor.text = purchaseObj.vendor;
        lblOrderType.text = purchaseObj.order_type;
        lblAmount.text = [NSString stringWithFormat:@"%@", purchaseObj.amount];
        lblCurrency.text = purchaseObj.currency;
        
        
        if([[lblMainVendor.text lowercaseString] isEqualToString:@"lanier professional services"]){
            [imgViewVendor setImage:[UIImage imageNamed:@"avatar-1.png"]];
            lblLocation.text = @"  Victoria, Canada";
        }else if([[lblMainVendor.text lowercaseString] isEqualToString:@"tlf services"]){
            [imgViewVendor setImage:[UIImage imageNamed:@"avatar-2.png"]];
            lblLocation.text = @"  Sydney, Australia";
        }else{
            [imgViewVendor setImage:[UIImage imageNamed:@"avatar-3.png"]];
            lblLocation.text = @"  Florida, US";
        }
        
        if([[purchaseObj approved] isEqualToNumber:[NSNumber numberWithBool:NO]] &&
           [[purchaseObj declined] isEqualToNumber:[NSNumber numberWithBool:NO]]){
            _btnApproved.hidden = _btnDeclined.hidden = NO;
        }
        
        [_tblPoItems reloadData];
        [_tblPoInvoices reloadData];
        [_tblPoDelivery reloadData];
    }else{
        [_tblPoInvoices setHidden:YES];
        [_tblPoItems setHidden:YES];
        [_tblPoDelivery setHidden:YES];
        
        [_poItemsButton setUserInteractionEnabled:NO];
        [_poInvoiceButton setUserInteractionEnabled:NO];
        [_poDeliveryButton setUserInteractionEnabled:NO];
        
        lblPOId.text = lblMainVendor.text = lblPODate.text = lblVendor.text =
        lblOrderType.text = lblAmount.text = lblCurrency.text = lblLocation.text =  @"";
        [imgViewVendor setImage:[UIImage imageNamed:@""]];

    }
}

-(UITableViewCell *) initializePoItemsTable:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *branchCellIdentifier = [NSString stringWithFormat:@"PoItemCell"];
    UITableViewCell *cell;
    UILabel *lblItems, *lblA, *lblL, *lblMaterial, *lblShortText, *lblQuantity, *lblUnits, *lblPoDate;
    UIImageView *imgViewBackground;
    
    cell = [tableView dequeueReusableCellWithIdentifier:branchCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil] objectAtIndex:3];
        
    }
    
    
    lblItems = (UILabel *)[cell.contentView viewWithTag:1];
    lblA = (UILabel *)[cell.contentView viewWithTag:2];
    lblL = (UILabel *)[cell.contentView viewWithTag:3];
    lblMaterial = (UILabel *)[cell.contentView viewWithTag:4];
    lblShortText = (UILabel *)[cell.contentView viewWithTag:5];
    lblQuantity = (UILabel *)[cell.contentView viewWithTag:6];
    lblUnits = (UILabel *)[cell.contentView viewWithTag:7];
    lblPoDate = (UILabel *)[cell.contentView viewWithTag:8];
    imgViewBackground = (UIImageView *)[cell.contentView viewWithTag:30];
    //imgViewStatus = (UIImageView *)[cell.contentView viewWithTag:8];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row % 2 == 0){
        [cell setFrame:CGRectMake(0, 0, 665, 44)];
        [imgViewBackground  setBackgroundColor:[UIColor whiteColor]];
        
    }
    else{
        [cell setFrame:CGRectMake(0, 0, 665, 44)];
    }
    
    
    
    PO_Items  *poItemsObj = [_lstPoItems objectAtIndex:indexPath.row];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    
    lblItems.text = poItemsObj.items;
    lblA.text = [NSString stringWithFormat:@"%@", poItemsObj.a];
    lblL.text = [NSString stringWithFormat:@"%@", poItemsObj.l];
    lblMaterial.text = poItemsObj.material;
    lblShortText.text = poItemsObj.short_text;
    lblQuantity.text = [NSString stringWithFormat:@"%@", poItemsObj.quantity];
    lblUnits.text = poItemsObj.units;
    lblPoDate.text = [format stringFromDate:poItemsObj.delivery_date];
    
    return cell;
}


#pragma PO Delivery table cell delegate

-(UITableViewCell *) initializePoDeliveryTable:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *branchCellIdentifier = [NSString stringWithFormat:@"PoDeliveryCell"];
    UITableViewCell *cell;
    UILabel *lblPoDeliveryId, *lblDeliveryType, *lblDate, *lblStatus;
    UIImageView *imgViewBackground;
    
    cell = [tableView dequeueReusableCellWithIdentifier:branchCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil] objectAtIndex:4];
        
    }
    
    
    lblPoDeliveryId = (UILabel *)[cell.contentView viewWithTag:1];
    lblDeliveryType = (UILabel *)[cell.contentView viewWithTag:2];
    lblDate = (UILabel *)[cell.contentView viewWithTag:3];
    lblStatus = (UILabel *)[cell.contentView viewWithTag:4];
    imgViewBackground = (UIImageView *)[cell.contentView viewWithTag:30];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row % 2 == 0){
        [cell setFrame:CGRectMake(0, 0, 665, 44)];
        [imgViewBackground  setBackgroundColor:[UIColor whiteColor]];
        
    }
    else{
        [cell setFrame:CGRectMake(0, 0, 665, 44)];
    }
    
    
    PO_Delivery  *poDeliveryObj = [_lstPoDelivery objectAtIndex:indexPath.row];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    
    lblPoDeliveryId.text = [NSString stringWithFormat:@"%@", poDeliveryObj.po_delivery_id];
    lblDeliveryType.text = poDeliveryObj.delivery_type;
    lblStatus.text = [NSString stringWithFormat:@"%@", poDeliveryObj.status];
    lblDate.text = [format stringFromDate:poDeliveryObj.delivery_date];
    
    return cell;
}


#pragma PO Invoice table cell delegate

-(UITableViewCell *) initializePoInvoicesTable:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *branchCellIdentifier = [NSString stringWithFormat:@"PoInvoiceCell"];
    UITableViewCell *cell;
    UILabel *lblPoInvoiceId, *lblInvoiceDate, *lblAmount;
    UIImageView *imgViewBackground;
    
    cell = [tableView dequeueReusableCellWithIdentifier:branchCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil] objectAtIndex:5];
        
    }
    
    
    lblPoInvoiceId = (UILabel *)[cell.contentView viewWithTag:1];
    lblInvoiceDate = (UILabel *)[cell.contentView viewWithTag:2];
    lblAmount = (UILabel *)[cell.contentView viewWithTag:3];
    
    imgViewBackground = (UIImageView *)[cell.contentView viewWithTag:30];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row % 2 == 0){
        [cell setFrame:CGRectMake(0, 0, 665, 44)];
        [imgViewBackground  setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [cell setFrame:CGRectMake(0, 0, 665, 44)];
    }
    
    
    PO_Invoice  *poInvoiceObj = [_lstPoInvoices objectAtIndex:indexPath.row];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    
    lblAmount.text = [NSString stringWithFormat:@"%@", poInvoiceObj.amount];
    lblPoInvoiceId.text = [NSString stringWithFormat:@"%@", poInvoiceObj.po_invoice_id];
    lblInvoiceDate.text = [format stringFromDate:poInvoiceObj.invoice_date];
    
    return cell;
}

- (IBAction)poDetailsBtnPressed:(id)sender {
    
    if(sender == self.poItemsButton){
        
        self.poItemsButton.userInteractionEnabled = FALSE;
        self.poItemsButton.alpha = 1.0f;
        self.poDeliveryButton.userInteractionEnabled = self.poInvoiceButton.userInteractionEnabled = !self.poItemsButton.userInteractionEnabled;
        self.poDeliveryButton.alpha = self.poInvoiceButton.alpha = 0.7f;
        
        _tblPoItems.hidden = NO;
        _tblPoDelivery.hidden = _tblPoInvoices.hidden = YES;
        
    }else if(sender == self.poDeliveryButton){
        
        self.poDeliveryButton.userInteractionEnabled = FALSE;
        self.poDeliveryButton.alpha = 1.0f;
        self.poItemsButton.userInteractionEnabled = self.poInvoiceButton.userInteractionEnabled = !self.poDeliveryButton.userInteractionEnabled;
        self.poItemsButton.alpha = self.poInvoiceButton.alpha = 0.7f;
        
        _tblPoDelivery.hidden = NO;
        _tblPoItems.hidden = _tblPoInvoices.hidden = YES;
        
    }else if (sender == self.poInvoiceButton){
        
        self.poInvoiceButton.userInteractionEnabled = FALSE;
        self.poInvoiceButton.alpha = 1.0f;
        self.poDeliveryButton.userInteractionEnabled = self.poItemsButton.userInteractionEnabled = !self.poInvoiceButton.userInteractionEnabled;
        self.poDeliveryButton.alpha = self.poItemsButton.alpha = 0.7f;
        
        _tblPoInvoices.hidden = NO;
        _tblPoDelivery.hidden = _tblPoItems.hidden = YES;
    }
    
}
@end
