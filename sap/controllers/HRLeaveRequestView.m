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
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UITableView *tblLeave;
@property (retain, nonatomic) NSMutableArray *lstLeave;
@property (retain, nonatomic) NSMutableArray *lstFilterLeave;
@property (retain, nonatomic) NSMutableString *filterText;
@property (nonatomic) BOOL isApprovedSelected;
@property (nonatomic) BOOL isUnApprovedSelected;
@property (retain, nonatomic) NSIndexPath* selectedIndexPath;


// fields
@property (retain, nonatomic) IBOutlet UIView *vwDetailRequestApproval;
@property (retain, nonatomic) IBOutlet UIButton *btnLeaveType;
@property (retain, nonatomic) IBOutlet UIButton *btnAppliedDate;
@property (retain, nonatomic) IBOutlet UIButton *btnDuration;
@property (retain, nonatomic) IBOutlet UIButton *btnFromDate;
@property (retain, nonatomic) IBOutlet UIButton *btnToDate;
@property (retain, nonatomic) IBOutlet UIButton *btnApprover;
@property (retain, nonatomic) IBOutlet UITextView *tvNotes;

//selectors
- (IBAction)btnPressedFilterApproved:(id)sender;
- (IBAction)btnPressedFilterUnApproved:(id)sender;
- (IBAction)btnPressedApproved:(id)sender;
- (IBAction)btnPressedUnApproved:(id)sender;

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
    
    [self setKeyBoardForSearchBar];
    [_tblLeave setShowsVerticalScrollIndicator:NO];
}


-(void) initializeData  : (AppDelegate *) sapDelegate{
    
    _sapDelegate = sapDelegate;
    _lstFilterLeave = [[NSMutableArray alloc] init];
    _lstLeave = [[NSMutableArray alloc] init];
    _filterText = [NSMutableString stringWithFormat:@""];
    _isApprovedSelected = YES;
    _isUnApprovedSelected = YES;
    _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    
    // data base calling for fetching data
    [self fetchDataFromServer];
}

- (void) fetchDataFromServer {
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HR_leaves"
                                              inManagedObjectContext:_sapDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    [_lstLeave addObjectsFromArray:[_sapDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    [_lstFilterLeave addObjectsFromArray:_lstLeave];
    
}

// selectors
- (IBAction)btnPressedFilterApproved:(id)sender{
    
    _isApprovedSelected = !_isApprovedSelected;
    [(UIButton *)sender setImage:[UIImage imageNamed:_isApprovedSelected ? @"check2" : @"check"] forState:UIControlStateNormal];
    
    [self filterLeaves];
    [self updateViews ];
}

- (IBAction)btnPressedFilterUnApproved:(id)sender{
    
    _isUnApprovedSelected = !_isUnApprovedSelected;
    [(UIButton *)sender setImage:[UIImage imageNamed:_isUnApprovedSelected ? @"check2" : @"check"] forState:UIControlStateNormal];
    
    [self filterLeaves];
    [self updateViews ];
}

- (IBAction)btnPressedApproved:(id)sender {
}

- (IBAction)btnPressedUnApproved:(id)sender {
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
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar setText:@""];
    [searchBar resignFirstResponder];
    [_filterText setString:searchBar.text];
    [self filterLeaves];
    [self updateViews];
}

- (void) filterLeaves {
    
    [_lstFilterLeave removeAllObjects];
    [_filterText setString:[_filterText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    if([_filterText length] > 0){
        
        for(HR_leaves *leave in _lstLeave){
            
            
            if(_isApprovedSelected && _isUnApprovedSelected
               && [[[leave leave_type] lowercaseString] rangeOfString:[_filterText lowercaseString]].location != NSNotFound){
                
                [_lstFilterLeave addObject:leave];
            }
            else{
                
                if(_isApprovedSelected && [[leave approved] isEqualToNumber:[NSNumber numberWithBool:YES]]
                   && [[[leave leave_type] lowercaseString] rangeOfString:[_filterText lowercaseString]].location != NSNotFound){
                    [_lstFilterLeave addObject:leave];
                }
                
                if(_isUnApprovedSelected && [[leave approved] isEqualToNumber:[NSNumber numberWithBool:NO]]
                   && [[[leave leave_type] lowercaseString] rangeOfString:[_filterText lowercaseString]].location != NSNotFound){
                    
                    [_lstFilterLeave addObject:leave];
                }
            }
        }
    }
    else{
        
        for(HR_leaves *leave in _lstLeave){
            
            if(_isApprovedSelected && _isUnApprovedSelected){
                
                [_lstFilterLeave addObject:leave];
            }
            else{
                
                if(_isApprovedSelected && [[leave approved] isEqualToNumber:[NSNumber numberWithBool:YES]]){
                    [_lstFilterLeave addObject:leave];
                }
                
                if(_isUnApprovedSelected && [[leave approved] isEqualToNumber:[NSNumber numberWithBool:NO]]){
                    [_lstFilterLeave addObject:leave];
                }
            }
        }
    }
}

// you have to update the view also have to change the side vise fileds accordingly
-(void) updateViews {
    
    [_tblLeave reloadData];
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
    
    if(_selectedIndexPath.row == indexPath.row){
        
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
        [lblFromDate setTextColor:[UIColor blackColor]];
        [lbltoDate setTextColor:[UIColor blackColor]];
        [lblReason setTextColor:[UIColor blackColor]];
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
    [_tblLeave reloadData];
    
}



@end
