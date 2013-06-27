//
//  HRLeaveRequest.m
//  sap
//
//  Created by goodcore2 on 6/20/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import "HRLeaveRequestView.h"


@interface HRLeaveRequestView ()

@property (retain, nonatomic) IBOutlet UIView *hrLeaveRequest;

@property (nonatomic, strong) AppDelegate *sapDelegate;
@property (retain, nonatomic) IBOutlet UIView *vwStatusPanel;
@property (retain, nonatomic) IBOutlet UILabel *lblStatusPanel;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UITableView *tblLeave;
@property (retain, nonatomic) NSMutableArray *lstLeave;
@property (retain, nonatomic) NSMutableArray *lstFilterLeave;
@property (retain, nonatomic) NSMutableString *filterText;
@property (nonatomic) BOOL isApprovedSelected;
@property (nonatomic) BOOL isDeclinedSelected;
@property (nonatomic) BOOL isPendingSelected;
@property (retain, nonatomic) NSNumber *selectedId;
@property (retain, nonatomic) NSIndexPath* selectedIndexPath;


// fields
@property (retain, nonatomic) IBOutlet UIView *vwDetailLeaveRequest;
@property (retain, nonatomic) IBOutlet UIButton *btnLeaveType;
@property (retain, nonatomic) IBOutlet UIButton *btnAppliedDate;
@property (retain, nonatomic) IBOutlet UIButton *btnDuration;
@property (retain, nonatomic) IBOutlet UIButton *btnFromDate;
@property (retain, nonatomic) IBOutlet UIButton *btnToDate;
@property (retain, nonatomic) IBOutlet UIButton *btnApprover;
@property (retain, nonatomic) IBOutlet UITextView *tvNotes;

@property (retain, nonatomic) IBOutlet UIButton *btnSubmit;
@property (retain, nonatomic) IBOutlet UIButton *btnCancel;

//selectors
- (IBAction)btnPressedFilterApproved:(id)sender;
- (IBAction)btnPressedFilterDeclined:(id)sender;
- (IBAction)btnPressedFilterPending:(id)sender;
- (IBAction)btnPressedSubmitted:(id)sender;
- (IBAction)btnPressedCancel:(id)sender;

@end

@implementation HRLeaveRequestView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame sapDelegate : (AppDelegate *) sapDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSBundle mainBundle] loadNibNamed:@"HRLeaveRequestView" owner:self options:nil];
        [self initializeViews:frame];
        [self initializeData:sapDelegate];
    }
    return self;
}


- (void) initializeViews : (CGRect) frame {
    
    frame.origin.y = 0;
    self.hrLeaveRequest.frame = frame;
    [self addSubview:self.hrLeaveRequest];    
    
    // saerch keyboard config
    [self setKeyBoardForSearchBar];
    
    // tbl config
    [_tblLeave setShowsVerticalScrollIndicator:NO];
    [_tblLeave setShowsHorizontalScrollIndicator:NO];
    
    
    // detail view
    // status panel
    [_vwStatusPanel.layer setCornerRadius:3.0f];
    [_vwStatusPanel setHidden:YES];
    
    [_vwDetailLeaveRequest.layer setCornerRadius:4.0f];
    [_vwDetailLeaveRequest.layer setBorderWidth:1.0f];
    [_vwDetailLeaveRequest.layer setBorderColor:[UIColor colorWithRed:225/255.f green:225/255.f blue:225/255.f alpha:1.0].CGColor];
    
    // disable all buttons
    [_btnLeaveType setUserInteractionEnabled:NO];
    [_btnLeaveType setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, 0.0)];
    
    [_btnAppliedDate setUserInteractionEnabled:NO];
    [_btnAppliedDate setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    [_btnDuration setUserInteractionEnabled:NO];
    [_btnDuration setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    [_btnFromDate setUserInteractionEnabled:NO];
    [_btnFromDate setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    [_btnToDate setUserInteractionEnabled:NO];
    [_btnToDate setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    [_btnApprover setUserInteractionEnabled:NO];
    [_btnApprover setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, 0.0)];
    
    [_tvNotes setUserInteractionEnabled:NO];
    [_tvNotes.layer setCornerRadius:4.0f];
    [_tvNotes.layer setBorderWidth:1.0f];
    [_tvNotes.layer setBorderColor:[UIColor colorWithRed:225/255.f green:225/255.f blue:225/255.f alpha:1.0].CGColor];
}

- (void) setSearchBarCancelButtonStyle {
    for (UIView *possibleButton in _searchBar.subviews)
    {
        if ([possibleButton isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton*)possibleButton;
            cancelButton.enabled = YES;
            [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [[cancelButton titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
            break;
        }
    }
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
        [UIView animateWithDuration:2.0 animations:^{
            [_vwStatusPanel setAlpha:0.1];
            
        } completion:^(BOOL finished) {
            [_vwStatusPanel setHidden:YES];
        }];
    }];
}


-(void) initializeData  : (AppDelegate *) sapDelegate{
    
    _sapDelegate = sapDelegate;
    _lstFilterLeave = [[NSMutableArray alloc] init];
    _lstLeave = [[NSMutableArray alloc] init];
    _filterText = [NSMutableString stringWithFormat:@""];
    _isApprovedSelected = YES;
    _isDeclinedSelected = YES;
    _isPendingSelected  = YES;
    _selectedIndexPath  = nil;
    
    // data base calling for fetching data
    [self fetchHRLeavesFromCoreData];
    [self filterLeaves];
    [self updateViews];
}


- (void) fetchHRLeavesFromCoreData {
    
    [_lstLeave removeAllObjects];
    [_lstLeave addObjectsFromArray:[self fetchDataFromCoreDataWithPredicate:nil AndEntityName:@"HR_leaves"]];
}

- (NSArray *) fetchDataFromCoreDataWithPredicate: (NSPredicate *) predicate AndEntityName:(NSString *) entityName {
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:_sapDelegate.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    return [_sapDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

// selectors
- (IBAction)btnPressedFilterApproved:(id)sender{
    
    _isApprovedSelected = !_isApprovedSelected;
    [(UIButton *)sender setImage:[UIImage imageNamed:_isApprovedSelected ? @"checkGreenHover" : @"checkGreen"] forState:UIControlStateNormal];
    
    [self filterLeaves];
    [self updateViews ];
}

- (IBAction)btnPressedFilterDeclined:(id)sender{
    
    _isDeclinedSelected = !_isDeclinedSelected;
    [(UIButton *)sender setImage:[UIImage imageNamed:_isDeclinedSelected ? @"checkRedHover" : @"checkRed"] forState:UIControlStateNormal];
    
    [self filterLeaves];
    [self updateViews ];
}

- (IBAction)btnPressedFilterPending:(id)sender{
    
    _isPendingSelected = !_isPendingSelected;
    [(UIButton *)sender setImage:[UIImage imageNamed:_isPendingSelected ? @"checkYellowHover" : @"checkYellow"] forState:UIControlStateNormal];
    
    [self filterLeaves];
    [self updateViews ];
}

- (IBAction)btnPressedSubmitted:(id)sender {
    
    // hide keyboard
    [self endEditing:YES];
    [self setSearchBarCancelButtonStyle];
    
    if(_selectedIndexPath && _selectedIndexPath.row >= 0){

        
        HR_leaves *leave;
        NSError *error;

        @try {
            
            leave =  [_lstFilterLeave objectAtIndex:_selectedIndexPath.row];
            [leave setSubmitted:[NSNumber numberWithBool:YES]];
            [leave setApplied_date:[NSDate date]];
            [_sapDelegate.managedObjectContext save:&error];
            
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", error);
        }
        @finally {
            
            if(!error){
                
                if(_isPendingSelected){
                    [self showPanelBarWithMessage:YES msg:@"Request has been submitted successfully"];
                    [_tblLeave reloadRowsAtIndexPaths: [NSArray arrayWithObject:_selectedIndexPath]
                                     withRowAnimation:UITableViewRowAnimationLeft];
                    
                }
                else{
                    [_tblLeave reloadRowsAtIndexPaths: [NSArray arrayWithObject:_selectedIndexPath]
                                     withRowAnimation:UITableViewRowAnimationTop];
                    
                    [UIView transitionWithView:_vwDetailLeaveRequest
                                      duration:0.75
                                       options:UIViewAnimationOptionTransitionCurlDown
                                    animations:nil
                                    completion:^(BOOL finished) {
                                        [self showPanelBarWithMessage:YES msg:@"Request has been submitted successfully and moved into Pending panel"];
                                    }];
                }
                
                [self filterLeaves];
                [self updateViews ];
            }
            else{
             
                [self showPanelBarWithMessage:NO msg:@"Request submit failed"];
            }
        }
    }
}

- (IBAction)btnPressedCancel:(id)sender {

    // hide keyboard
    [self endEditing:YES];
    [self setSearchBarCancelButtonStyle];
    
    if(_selectedIndexPath && _selectedIndexPath.row >= 0){
        
        HR_leaves *leave;
        
        BOOL isError = NO;
        @try {
            
            leave =  [_lstFilterLeave objectAtIndex:_selectedIndexPath.row];
            [_sapDelegate.managedObjectContext deleteObject:leave];
        }
        @catch (NSException *exception) {
            isError = YES;
            
            NSLog(@"Exception: %@", exception);
        }
        @finally {
            
            if(!isError){
                
                [_tblLeave reloadRowsAtIndexPaths: [NSArray arrayWithObject:_selectedIndexPath]
                                 withRowAnimation:UITableViewRowAnimationTop];
                [_lstLeave removeObject:leave];
                [self filterLeaves];
                [self updateViews ];
                
                [UIView transitionWithView:_vwDetailLeaveRequest
                                  duration:0.75
                                   options:UIViewAnimationOptionTransitionCurlDown
                                animations:nil
                                completion:^(BOOL finished) {
                                    [self showPanelBarWithMessage:YES msg:@"Request has been deleted successfully"];
                                }];
            }
            else{
                
                [self showPanelBarWithMessage:NO msg:@"Request delete failed"];
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
    [self filterLeaves];
    [self updateViews];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    // search logic will go here
    [searchBar resignFirstResponder];
    [self setSearchBarCancelButtonStyle];
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar setText:@""];
    [searchBar resignFirstResponder];
    [_filterText setString:searchBar.text];
    [self filterLeaves];
    [self updateViews];
}

- (void) filterLeaves {
    
    _selectedIndexPath = nil;
    [_lstFilterLeave removeAllObjects];
    [_filterText setString:[_filterText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    if([_filterText length] > 0){
        
        for(HR_leaves *leave in _lstLeave){
            
            if([[[leave leave_type] lowercaseString] rangeOfString:[_filterText lowercaseString]].location != NSNotFound){
                
                if(_isApprovedSelected
                   && [[leave isProcessed] isEqualToNumber:[NSNumber numberWithBool:YES]]
                   && [[leave approved] isEqualToNumber:[NSNumber numberWithBool:YES]]){
                    
                    [_lstFilterLeave addObject:leave];
                }
                else if(_isDeclinedSelected
                        && [[leave isProcessed] isEqualToNumber:[NSNumber numberWithBool:YES]]
                        && [[leave approved] isEqualToNumber:[NSNumber numberWithBool:NO]]){
                    
                    [_lstFilterLeave addObject:leave];
                }
                else if(_isPendingSelected
                        && [[leave isProcessed] isEqualToNumber:[NSNumber numberWithBool:NO]]){
                    
                    [_lstFilterLeave addObject:leave];
                }
            }
        }
    }
    else{
        
        for(HR_leaves *leave in _lstLeave){
                
            if(_isApprovedSelected
               && [[leave isProcessed] isEqualToNumber:[NSNumber numberWithBool:YES]]
               && [[leave approved] isEqualToNumber:[NSNumber numberWithBool:YES]]){
                
                [_lstFilterLeave addObject:leave];
            }
            else if(_isDeclinedSelected
                    && [[leave isProcessed] isEqualToNumber:[NSNumber numberWithBool:YES]]
                    && [[leave approved] isEqualToNumber:[NSNumber numberWithBool:NO]]){
                
                [_lstFilterLeave addObject:leave];
            }
            else if(_isPendingSelected
                    && [[leave isProcessed] isEqualToNumber:[NSNumber numberWithBool:NO]]){
                
                [_lstFilterLeave addObject:leave];
            }
        }
    }
    
    [self updateSelectedIndexPath];
}

- (void) updateSelectedIndexPath {
    
    if(_lstFilterLeave.count > 0){
        
        NSInteger index;
        BOOL isExist = NO;
        
        if(_selectedId){
            
            for(index = 0; index < [_lstFilterLeave count]; index++){
                
                HR_leaves *obj = [_lstFilterLeave objectAtIndex:index];
                if([obj.leave_id isEqualToNumber:_selectedId]){
                    
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
    
    [_tblLeave reloadData];
    [_tblLeave scrollToRowAtIndexPath:_selectedIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    // search bar cancel button style
    [self setSearchBarCancelButtonStyle];
    
    // right side detail view
    [self updateLeaveApprovalRequest];
}

- (void) updateLeaveApprovalRequest{
    
    if(_selectedIndexPath && _selectedIndexPath.row >= 0){
        
        HR_leaves *leaveObj = [_lstFilterLeave objectAtIndex:_selectedIndexPath.row];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateStyle:NSDateFormatterMediumStyle];
        
        NSTimeInterval distanceBetweenDates = [leaveObj.to_date timeIntervalSinceDate:leaveObj.from_date];
        double secondsInDay = 60*60*24;
        NSInteger dayBetweenDates = distanceBetweenDates / secondsInDay;

        
        [_btnLeaveType setTitle:leaveObj.leave_type forState:UIControlStateNormal & UIControlStateSelected];
        [_btnAppliedDate setTitle:[format stringFromDate:leaveObj.applied_date] forState:UIControlStateNormal & UIControlStateSelected];
        [_btnDuration setTitle:[NSString stringWithFormat:@"%d Day(s)", dayBetweenDates] forState:UIControlStateNormal & UIControlStateSelected];
        [_btnFromDate setTitle:[format stringFromDate:leaveObj.from_date] forState:UIControlStateNormal & UIControlStateSelected];
        [_btnToDate setTitle:[format stringFromDate:leaveObj.to_date] forState:UIControlStateNormal & UIControlStateSelected];
        [_btnApprover setTitle:leaveObj.approver forState:UIControlStateNormal & UIControlStateSelected];
        [_tvNotes setText:leaveObj.notes];
        
        if([leaveObj.submitted isEqualToNumber:[NSNumber numberWithBool:NO]]){
            
            [_btnSubmit setHidden:NO];
            [_btnCancel setHidden:NO];
        }
        else{
            
            [_btnSubmit setHidden:YES];
            [_btnCancel setHidden:YES];
        }
    }
    else{
        
        [_btnLeaveType     setTitle:@"" forState:UIControlStateNormal & UIControlStateSelected];
        [_btnAppliedDate   setTitle:@"" forState:UIControlStateNormal & UIControlStateSelected];
        [_btnDuration     setTitle:@"" forState:UIControlStateNormal & UIControlStateSelected];
        [_btnFromDate       setTitle:@"" forState:UIControlStateNormal & UIControlStateSelected];
        [_btnToDate    setTitle:@"" forState:UIControlStateNormal & UIControlStateSelected];
        [_btnApprover    setTitle:@"" forState:UIControlStateNormal & UIControlStateSelected];
        [_tvNotes           setText:@""];
        
        [_btnSubmit setHidden:YES];
        [_btnCancel setHidden:YES];
    }
}


// delegates
#pragma table delagtes
#pragma sale table delagates
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [_lstFilterLeave count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *branchCellIdentifier = [NSString stringWithFormat:@"HRSearchCell"];
    UITableViewCell *cell;
    UILabel *lblFromDate, *lbltoDate, *lblDuration, *lblReason;
    UIImageView *imgViewBackground, *imgViewCalender, *imgViewStatus;
    UIView *vwSeperator;
    
    cell = [tableView dequeueReusableCellWithIdentifier:branchCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil] objectAtIndex:1];
        
    }
    
    imgViewBackground = (UIImageView *)[cell.contentView viewWithTag:10];
    imgViewCalender = (UIImageView *)[cell.contentView viewWithTag:20];
    imgViewStatus = (UIImageView *)[cell.contentView viewWithTag:110];
    
    vwSeperator = (UIView *)[cell.contentView viewWithTag:30];
    
    lblFromDate = (UILabel *)[cell.contentView viewWithTag:50];
    lbltoDate = (UILabel *)[cell.contentView viewWithTag:60];
    lblDuration = (UILabel *)[cell.contentView viewWithTag:70];
    lblReason = (UILabel *)[cell.contentView viewWithTag:80];
    
    // to round label
    [[lblDuration layer] setCornerRadius:3.0];
    
    if(_selectedIndexPath && _selectedIndexPath.row == indexPath.row){
        
        [cell setFrame:CGRectMake(0, 0, 275, 106)];
        [imgViewBackground setFrame:CGRectMake(0, 10, 275, 86)];
        [vwSeperator setFrame:CGRectMake(5, 50, 250, 1)];
        [imgViewBackground setImage:[UIImage imageNamed:@"DataBoxHover"]];
        [imgViewCalender setImage:[UIImage imageNamed:@"cal3"]];
        [lblFromDate setTextColor:[UIColor whiteColor]];
        [lbltoDate setTextColor:[UIColor whiteColor]];
        [lblReason setTextColor:[UIColor whiteColor]];
    }
    else{
        [cell setFrame:CGRectMake(0, 0, 270, 106)];
        [imgViewBackground setFrame:CGRectMake(0, 10, 270, 86)];
        [vwSeperator setFrame:CGRectMake(5, 50, 245, 1)];
        [imgViewBackground setImage:[UIImage imageNamed:@"DataBox"]];
        [imgViewCalender setImage:[UIImage imageNamed:@"calBlue"]];
        [lblFromDate setTextColor:[UIColor darkGrayColor]];
        [lbltoDate setTextColor:[UIColor darkGrayColor]];
        [lblReason setTextColor:[UIColor darkGrayColor]];
    }
    
    HR_leaves *leaveObj = [_lstFilterLeave objectAtIndex:indexPath.row];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    
    NSTimeInterval distanceBetweenDates = [leaveObj.to_date timeIntervalSinceDate:leaveObj.from_date];
    double secondsInDay = 60*60*24;
    NSInteger dayBetweenDates = distanceBetweenDates / secondsInDay;
    
    lblFromDate.text = [format stringFromDate:leaveObj.from_date];
    lbltoDate.text = [format stringFromDate:leaveObj.to_date];
    lblReason.text = leaveObj.leave_type;
    lblDuration.text = [NSString stringWithFormat:@"%d Days", dayBetweenDates];
    
    if([leaveObj.submitted isEqualToNumber:[NSNumber numberWithBool:YES]]){

        if([leaveObj.isProcessed isEqualToNumber:[NSNumber numberWithBool:YES]]){
            
            if([leaveObj.approved isEqualToNumber:[NSNumber numberWithBool:YES]]){
                [imgViewStatus setImage:[UIImage imageNamed:@"greenCircle"]];
            }
            else{
                [imgViewStatus setImage:[UIImage imageNamed:@"redCircle"]];
            }
        }
        else{
            [imgViewStatus setImage:[UIImage imageNamed:@"orangeCircle"]];
        }
    }
    else{
        
        [imgViewStatus setImage:[UIImage imageNamed:@"blueCircle"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    _selectedIndexPath = indexPath;
    HR_leaves *hrLeave = [_lstFilterLeave objectAtIndex:indexPath.row];
    _selectedId = hrLeave.leave_id;
    
    
    // hide keyboard
    [self endEditing:YES];
    [self setSearchBarCancelButtonStyle];
    
    // update view for changing selection background image
    [self updateViews ];
    
}

// touch delegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([_searchBar isFirstResponder] && [touch view] != _searchBar) {
        
        [self endEditing:YES];
        [self setSearchBarCancelButtonStyle];
    }
    [super touchesBegan:touches withEvent:event];
}


@end
