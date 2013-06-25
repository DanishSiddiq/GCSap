//
//  WorkOrder.m
//  sap
//
//  Created by goodcore1 on 6/24/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import "WorkOrderView.h"

@interface WorkOrderView()

@property (retain, nonatomic) IBOutlet UIView *mainView;

@property (nonatomic, strong) AppDelegate *sapDelegate;
@property (retain, nonatomic) NSMutableArray* lstWorkOrders;
@property (retain, nonatomic) NSMutableArray *lstFilterWorkOrders;
@property (retain, nonatomic) NSMutableString *filterText;
@property (retain, nonatomic) IBOutlet UIView* titleView;
@property (retain, nonatomic) NSIndexPath* selectedIndexPath;
@property (retain, nonatomic) IBOutlet UITableView *tblWorkOrders;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) BOOL isApprovedSelected;
@property (nonatomic) BOOL isPending;
@property (retain, nonatomic) IBOutlet UIView *contentVew;

@property (weak, nonatomic) Work_Order *currentWO;


@property bool _isSlided;

@end


@implementation WorkOrderView

- (id)initWithFrame:(CGRect)frame sapDelegate:(AppDelegate *)sapDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [[NSBundle mainBundle] loadNibNamed:@"WorkOrderView" owner:self options:nil];
        
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"topBar.png"]];
        self.titleView.backgroundColor = background;
        
        self.mainView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.mainView];
        
        //[_tblPurchases setShowsVerticalScrollIndicator:NO];
                
        self._isSlided = NO;
        [self initializeData:sapDelegate];
        
    }
    return self;
}

-(void) initializeData  : (AppDelegate *) sapDelegate{
    
    _sapDelegate = sapDelegate;
    _lstWorkOrders = [[NSMutableArray alloc] init];
    _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _lstFilterWorkOrders = [[NSMutableArray alloc] init];
    _filterText = [NSMutableString stringWithFormat:@""];
    _isApprovedSelected = _isPending = YES;
    
    // data base calling for fetching data
    _lstWorkOrders = [self fetchDataFromServerWithPredicate:nil AndEntityName:@"Work_Order"];
    [_lstFilterWorkOrders addObjectsFromArray:_lstWorkOrders];
    
    if(_lstFilterWorkOrders.count > 0){
        [self getSelectedWorkOrder:0];   
    }else{
        [self emptyControls];
    }

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

- (IBAction)btnSubmitPressed:(id)sender {
    
    
    [self.currentWO setStatus: [NSNumber numberWithBool:YES]];
    
    [_lstFilterWorkOrders replaceObjectAtIndex:_selectedIndexPath.row withObject:self.currentWO];
    
    NSError *error = nil;
	[_sapDelegate.managedObjectContext save:&error];
	
	if (error) {
		NSLog(@"[ERROR] COREDATA: Save raised an error - '%@'", [error description]);
		return;
	}
	
    self.currentWO = nil;
	
	[_tblWorkOrders reloadData];
    
    [self filterWorkOrders];
    [self updateViews ];
    
}

- (IBAction)btnCancelPressed:(id)sender {
    
}

// selectors
- (IBAction)btnPressedApproved:(id)sender {
    
    _isApprovedSelected = !_isApprovedSelected;
    [(UIButton *)sender setImage:[UIImage imageNamed:_isApprovedSelected ? @"check2" : @"check"] forState:UIControlStateNormal];
    
    [self filterWorkOrders];
    [self updateViews ];
    
}

- (IBAction)btnPressedPending:(id)sender {
    
    _isPending = !_isPending;
    [(UIButton *)sender setImage:[UIImage imageNamed:_isPending ? @"check2" : @"check"] forState:UIControlStateNormal];
    
    [self filterWorkOrders];
    [self updateViews ];
    
    
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
    [self filterWorkOrders];
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
    [self filterWorkOrders];
    [self updateViews];
    
}

- (void) filterWorkOrders {
    
    [_lstFilterWorkOrders removeAllObjects];
    [_filterText setString:[_filterText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    if([_filterText length] > 0){
        
        for(Work_Order *workOrder in _lstWorkOrders){
            
            // case when both checkboxes are selected
            if(_isApprovedSelected && [[workOrder status] isEqualToNumber:[NSNumber numberWithBool:YES]] &&
               [[[workOrder order_type] lowercaseString] rangeOfString:[_filterText lowercaseString]].location != NSNotFound){
                
                [_lstFilterWorkOrders addObject:workOrder];
                
            }
            
            else if(_isApprovedSelected && [[workOrder status] isEqualToNumber:[NSNumber numberWithBool:YES]] &&               [[[NSString stringWithFormat:@"%@", [workOrder order_id]] lowercaseString] rangeOfString:[_filterText lowercaseString]].location != NSNotFound){
                
                [_lstFilterWorkOrders addObject:workOrder];
                
            }
            
            if(_isPending && [[workOrder status] isEqualToNumber:[NSNumber numberWithBool:NO]] &&
               [[[workOrder order_type] lowercaseString] rangeOfString:[_filterText lowercaseString]].location != NSNotFound){
                [_lstFilterWorkOrders addObject:workOrder];
            }
            
            else if(_isPending && [[workOrder status] isEqualToNumber:[NSNumber numberWithBool:NO]] &&
               [[[NSString stringWithFormat:@"%@", [workOrder order_id]] lowercaseString] rangeOfString:[_filterText lowercaseString]].location != NSNotFound){
                [_lstFilterWorkOrders addObject:workOrder];
            }
        }
    }
    
    else{
        
         for(Work_Order *workOrder in _lstWorkOrders){
            
            if(_isApprovedSelected && [[workOrder status] isEqualToNumber:[NSNumber numberWithBool:YES]]){
                
                [_lstFilterWorkOrders addObject:workOrder];
            }
            
            if(_isPending && [[workOrder status] isEqualToNumber:[NSNumber numberWithBool:NO]]){
                
                [_lstFilterWorkOrders addObject:workOrder];
            }
         }
    }
    
    if(_lstFilterWorkOrders.count > 0){
        _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    else{
        self.btnCancel.enabled = self.btnSubmit.enabled = NO;
        _selectedIndexPath = nil;
        [self emptyControls];
    }
}

// you have to update the view also have to change the side vise fileds accordingly
-(void) updateViews {
    
    [_tblWorkOrders reloadData];
}


#pragma table delegates
#pragma purchase order delegates
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [_lstFilterWorkOrders count];
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
    
    NSString *branchCellIdentifier = [NSString stringWithFormat:@"WorkOrderCell"];
    UITableViewCell *cell;
    UILabel *lblOrderID, *lblStartDate, *lblOrderType;
    UIImageView *imgViewBackground, *imgViewCalender, *imgViewStatus;
    
    cell = [tableView dequeueReusableCellWithIdentifier:branchCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil] objectAtIndex:6];
        
    }
    
    imgViewBackground = (UIImageView *)[cell.contentView viewWithTag:7];
    imgViewCalender = (UIImageView *)[cell.contentView viewWithTag:40];
    imgViewStatus = (UIImageView *)[cell.contentView viewWithTag:41];
    
    
    lblOrderID = (UILabel *)[cell.contentView viewWithTag:1];
    lblStartDate = (UILabel *)[cell.contentView viewWithTag:2];
    lblOrderType = (UILabel *)[cell.contentView viewWithTag:3];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(_selectedIndexPath.row == indexPath.row){
        
        [cell setFrame:CGRectMake(0, 0, 292, 125)];
        [imgViewBackground setFrame:CGRectMake(0, 0, 292, 125)];
        [imgViewBackground setImage:[UIImage imageNamed:@"DataBoxHover"]];
        [imgViewCalender setImage:[UIImage imageNamed:@"cal3"]];
        [lblOrderID setTextColor:[UIColor whiteColor]];
        [lblStartDate setTextColor:[UIColor whiteColor]];
        [lblOrderType setTextColor:[UIColor whiteColor]];
    }
    else{
        [cell setFrame:CGRectMake(0, 0, 292, 125)];
        [imgViewBackground setFrame:CGRectMake(0, 0, 292, 125)];
        [imgViewBackground setImage:[UIImage imageNamed:@"DataBox"]];
        [imgViewCalender setImage:[UIImage imageNamed:@"calBlue"]];
        [lblOrderID setTextColor:[UIColor blackColor]];
        [lblStartDate setTextColor:[UIColor blackColor]];
        [lblOrderType setTextColor:[UIColor blackColor]];
    }
    
    Work_Order *workOrderObj = [_lstFilterWorkOrders objectAtIndex:indexPath.row];
    self.currentWO = workOrderObj;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];

    
    lblOrderID.text = [NSString stringWithFormat:@"%@", workOrderObj.order_id];
    lblStartDate.text = [format stringFromDate:workOrderObj.start_date];
    lblOrderType.text = workOrderObj.order_type;
    
    if([workOrderObj.status isEqualToNumber:[NSNumber numberWithBool:YES]]){
        
        [imgViewStatus setImage:[UIImage imageNamed:@"greenCircle"]];
    }
    else{

        [imgViewStatus setImage:[UIImage imageNamed:@"blueCircle"]];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndexPath = indexPath;
    [_tblWorkOrders reloadData];
        
    [self getSelectedWorkOrder:indexPath.row];

}

-(void) getSelectedWorkOrder:(NSInteger) withIndex{
    self.btnCancel.enabled = self.btnSubmit.enabled = YES;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    
    Work_Order *workOrderObj = [_lstFilterWorkOrders objectAtIndex:withIndex];
    UILabel *lblOrderID, *lblStartDate, *lblEndDate, *lblOrderType, *lblStatus, *lblUpdatedBy, *lblLastUpdated, *lblEquipment, *lblSerialNumber, *lblPriority, *lblWordCenter;
    UITextView *txtViewNotes;
    
    lblOrderID = (UILabel *)[self.contentVew viewWithTag:1];
    lblOrderType = (UILabel *)[self.contentVew viewWithTag:2];
    lblStartDate = (UILabel *)[self.contentVew viewWithTag:3];
    lblEndDate = (UILabel *)[self.contentVew viewWithTag:4];
    lblPriority = (UILabel *)[self.contentVew viewWithTag:5];
    lblSerialNumber = (UILabel *)[self.contentVew viewWithTag:6];
    lblEquipment = (UILabel *)[self.contentVew viewWithTag:7];
    lblWordCenter = (UILabel *)[self.contentVew viewWithTag:8];
    lblStatus = (UILabel *)[self.contentVew viewWithTag:9];
    lblLastUpdated = (UILabel *)[self.contentVew viewWithTag:10];
    lblUpdatedBy = (UILabel *)[self.contentVew viewWithTag:11];
    txtViewNotes = (UITextView *)[self.contentVew viewWithTag:50];
    
    lblOrderID.text = [NSString stringWithFormat:@"%@", workOrderObj.order_id];
    lblLastUpdated.text = [format stringFromDate:workOrderObj.last_updated];
    lblEndDate.text = [format stringFromDate:workOrderObj.end_date];
    lblStartDate.text = [format stringFromDate:workOrderObj.start_date];
    lblOrderType.text = workOrderObj.order_type;
    lblStatus.text = [workOrderObj.status isEqualToNumber:[NSNumber numberWithBool:YES]] ? @"Closed" : @"Open";
    lblUpdatedBy.text = workOrderObj.updated_by;
    lblWordCenter.text = workOrderObj.word_center;
    lblEquipment.text = workOrderObj.equipment;
    lblPriority.text = workOrderObj.priority;
    lblSerialNumber.text = workOrderObj.serial_number;
    txtViewNotes.text = workOrderObj.notes;
    
    if([workOrderObj.status isEqualToNumber:[NSNumber numberWithBool:YES]]){
        self.btnCancel.enabled = self.btnSubmit.enabled = NO;
    }
}

- (IBAction)btnTabPressed:(id)sender{
    
    [self.btnOverview setBackgroundImage:[UIImage imageNamed:@"rsz_overview.png"] forState:UIControlStateNormal];
    [self.btnOperations setBackgroundImage:[UIImage imageNamed:@"rsz_operations.png"] forState:UIControlStateNormal];
    [self.btnComponents setBackgroundImage:[UIImage imageNamed:@"rsz_components.png"] forState:UIControlStateNormal];
    [self.btnBusiness setBackgroundImage:[UIImage imageNamed:@"rsz_businesspartners.png"] forState:UIControlStateNormal];
    [self.btnMaterial setBackgroundImage:[UIImage imageNamed:@"rsz_matetialconf.png"] forState:UIControlStateNormal];
    
    if(sender == self.btnOverview){
        [self.btnOverview setBackgroundImage:[UIImage imageNamed:@"rsz_overviewhover.png"] forState:UIControlStateNormal];
        
    }else if(sender == self.btnOperations){
        [self.btnOperations setBackgroundImage:[UIImage imageNamed:@"rsz_operationshover.png"] forState:UIControlStateNormal];
        
    }else if(sender == self.btnComponents){
        [self.btnComponents setBackgroundImage:[UIImage imageNamed:@"rsz_componentshover.png"] forState:UIControlStateNormal];
        
    }else if(sender == self.btnBusiness){
        [self.btnBusiness setBackgroundImage:[UIImage imageNamed:@"rsz_businesspartnershover.png"] forState:UIControlStateNormal];
        
    }else if(sender == self.btnMaterial){
        [self.btnMaterial setBackgroundImage:[UIImage imageNamed:@"rsz_matetialconfhover.png"] forState:UIControlStateNormal];
        
    }
    
}

-(void) emptyControls{
    UILabel *lblOrderID, *lblStartDate, *lblEndDate, *lblOrderType, *lblStatus, *lblUpdatedBy, *lblLastUpdated, *lblEquipment, *lblSerialNumber, *lblPriority, *lblWordCenter;
    UITextView *txtViewNotes;
    
    lblOrderID = (UILabel *)[self.contentVew viewWithTag:1];
    lblOrderType = (UILabel *)[self.contentVew viewWithTag:2];
    lblStartDate = (UILabel *)[self.contentVew viewWithTag:3];
    lblEndDate = (UILabel *)[self.contentVew viewWithTag:4];
    lblPriority = (UILabel *)[self.contentVew viewWithTag:5];
    lblSerialNumber = (UILabel *)[self.contentVew viewWithTag:6];
    lblEquipment = (UILabel *)[self.contentVew viewWithTag:7];
    lblWordCenter = (UILabel *)[self.contentVew viewWithTag:8];
    lblStatus = (UILabel *)[self.contentVew viewWithTag:9];
    lblLastUpdated = (UILabel *)[self.contentVew viewWithTag:10];
    lblUpdatedBy = (UILabel *)[self.contentVew viewWithTag:11];
    txtViewNotes = (UITextView *)[self.contentVew viewWithTag:50];
    
    lblOrderID.text =
    lblLastUpdated.text =
    lblEndDate.text =
    lblStartDate.text =
    lblOrderType.text =
    lblStatus.text =
    lblUpdatedBy.text =
    lblWordCenter.text =
    lblEquipment.text =
    lblPriority.text =
    lblSerialNumber.text =
    txtViewNotes.text = @"";

}

@end
