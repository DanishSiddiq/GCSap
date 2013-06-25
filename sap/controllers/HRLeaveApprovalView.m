//
//  HRLeaveApprovalView.m
//  sap
//
//  Created by goodcore2 on 6/20/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import "HRLeaveApprovalView.h"

@interface HRLeaveApprovalView ()

@property (nonatomic, strong) AppDelegate *sapDelegate;
@property (retain, nonatomic) IBOutlet UITableView *tblLeave;
@property (retain, nonatomic) IBOutlet UIView *hrLeaveApproval;
@property (retain, nonatomic) IBOutlet UIView *vwStatusPanel;
@property (retain, nonatomic) IBOutlet UILabel *lblStatusPanel;
@property (retain, nonatomic) NSMutableArray *lstLeave;
@property (retain, nonatomic) NSMutableArray *lstFilterLeave;
@property (nonatomic) BOOL isApprovedSelected;
@property (nonatomic) BOOL isDeclinedSelected;
@property (nonatomic) BOOL isPendingSelected;
@property (retain, nonatomic) NSIndexPath* selectedIndexPath;

// detail view
@property (retain, nonatomic) IBOutlet UIView *vwDetailLeaveApproval;
@property (retain, nonatomic) IBOutlet UIButton *btnEmployeeID;
@property (retain, nonatomic) IBOutlet UIButton *btnEmployeeName;
@property (retain, nonatomic) IBOutlet UIButton *btnDepartment;
@property (retain, nonatomic) IBOutlet UIButton *btnDuration;
@property (retain, nonatomic) IBOutlet UIButton *btnAppliedDate;
@property (retain, nonatomic) IBOutlet UIButton *btnFromDate;
@property (retain, nonatomic) IBOutlet UIButton *btnToDate;
@property (retain, nonatomic) IBOutlet UIButton *btnLeaveType;
@property (retain, nonatomic) IBOutlet UITextView *tvNotes;
@property (retain, nonatomic) IBOutlet UIButton *btnApprove;
@property (retain, nonatomic) IBOutlet UIButton *btnDecline;

//selectors
- (IBAction)btnPressedFilterApproved:(id)sender;
- (IBAction)btnPressedFilterDeclined:(id)sender;
- (IBAction)btnPressedFilterPending:(id)sender;
- (IBAction)btnPressedApprove:(id)sender;
- (IBAction)btnPressedDecline:(id)sender;

@end

@implementation HRLeaveApprovalView

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
        
        [[NSBundle mainBundle] loadNibNamed:@"HRLeaveApprovalView" owner:self options:nil];
        [self initializeData:sapDelegate];
        [self initializeViews:frame];
    }
    return self;
}


- (void) initializeViews : (CGRect) frame {
    
    frame.origin.y = 0;
    self.hrLeaveApproval.frame = frame;
    [self addSubview:self.hrLeaveApproval];
    
    [_tblLeave setShowsVerticalScrollIndicator:NO];
    [_tblLeave setShowsHorizontalScrollIndicator:NO];
    
    
    // detail view
    // status panel
    [_vwStatusPanel.layer setCornerRadius:3.0f];
    [_vwStatusPanel setHidden:YES];
    
    [_vwDetailLeaveApproval.layer setCornerRadius:4.0f];
    [_vwDetailLeaveApproval.layer setBorderWidth:1.0f];
    [_vwDetailLeaveApproval.layer setBorderColor:[UIColor colorWithRed:225/255.f green:225/255.f blue:225/255.f alpha:1.0].CGColor];
    
    // disable all buttons    
    [_btnEmployeeID setUserInteractionEnabled:NO];
    [_btnEmployeeID setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    [_btnEmployeeName setUserInteractionEnabled:NO];
    [_btnEmployeeName setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
 
    [_btnDepartment setUserInteractionEnabled:NO];
    [_btnDepartment setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];

    [_btnDuration setUserInteractionEnabled:NO];
    [_btnDuration setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    [_btnAppliedDate setUserInteractionEnabled:NO];
    [_btnAppliedDate setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    [_btnFromDate setUserInteractionEnabled:NO];
    [_btnFromDate setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    [_btnToDate setUserInteractionEnabled:NO];
    [_btnToDate setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    [_btnLeaveType setUserInteractionEnabled:NO];
    [_btnLeaveType setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, 0.0)];

    [_tvNotes setUserInteractionEnabled:NO];
    [_tvNotes.layer setCornerRadius:4.0f];
    [_tvNotes.layer setBorderWidth:1.0f];
    [_tvNotes.layer setBorderColor:[UIColor colorWithRed:225/255.f green:225/255.f blue:225/255.f alpha:1.0].CGColor];
    
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

-(void) initializeData  : (AppDelegate *) sapDelegate{
    
    _sapDelegate = sapDelegate;
    _lstFilterLeave = [[NSMutableArray alloc] init];
    _lstLeave = [[NSMutableArray alloc] init];
    _isApprovedSelected = YES;
    _isDeclinedSelected = YES;
    _isPendingSelected = YES;
    _selectedIndexPath = nil;
    
    // data base calling for fetching data and refreshign data
    [self fetchHRLeavesFromCoreData];
    [self filterLeaves];
    [self updateViews];
}

- (void) fetchHRLeavesFromCoreData {
    
    [_lstLeave removeAllObjects];
        NSPredicate * predicate = [NSPredicate predicateWithFormat: @"(submitted = %@)", [NSNumber numberWithBool:YES]];
    [_lstLeave addObjectsFromArray:[self fetchDataFromCoreDataWithPredicate:predicate AndEntityName:@"HR_leaves"]];
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
- (IBAction)btnPressedFilterApproved:(id)sender {
    
    _isApprovedSelected = !_isApprovedSelected;
    [(UIButton *)sender setImage:[UIImage imageNamed:_isApprovedSelected ? @"check2" : @"check"] forState:UIControlStateNormal];
    
    [self filterLeaves];
    [self updateViews ];
}

- (IBAction)btnPressedFilterDeclined:(id)sender {
    
    _isDeclinedSelected = !_isDeclinedSelected;
    [(UIButton *)sender setImage:[UIImage imageNamed:_isDeclinedSelected ? @"check2" : @"check"] forState:UIControlStateNormal];
    
    [self filterLeaves];
    [self updateViews ];
}

- (IBAction)btnPressedFilterPending:(id)sender{
    
    _isPendingSelected = !_isPendingSelected;
    [(UIButton *)sender setImage:[UIImage imageNamed:_isPendingSelected ? @"check2" : @"check"] forState:UIControlStateNormal];
    
    [self filterLeaves];
    [self updateViews ];
}

- (IBAction)btnPressedApprove:(id)sender{
    
    if(_selectedIndexPath && _selectedIndexPath.row >= 0){
        
        NSError *error;
        HR_leaves *leave;
        
        @try {
            
            leave =  [_lstFilterLeave objectAtIndex:_selectedIndexPath.row];
            [leave setIsProcessed:[NSNumber numberWithBool:YES]];
            [leave setApproved:[NSNumber numberWithBool:YES]];
            [_sapDelegate.managedObjectContext save:&error];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", error);
        }
        @finally {
            
            if(!error){
                
                if(_isApprovedSelected){
                    [self showPanelBarWithMessage:YES msg:@"Request has been approved successfully"];
                }
                else{
                    [self showPanelBarWithMessage:YES msg:@"Request has been approved successfully and moved into Approved panel"];
                }                
                
                [self filterLeaves];
                [self updateViews ];
            }
            else{
                
                [self showPanelBarWithMessage:NO msg:@"Request approve failed"];
            }
        }
    }
    
}

- (IBAction)btnPressedDecline:(id)sender{
    
    if(_selectedIndexPath && _selectedIndexPath.row >= 0){
        
        NSError *error;
        HR_leaves *leave;
        
        @try {
            
            leave =  [_lstFilterLeave objectAtIndex:_selectedIndexPath.row];
            [leave setIsProcessed:[NSNumber numberWithBool:YES]];
            [leave setApproved:[NSNumber numberWithBool:NO]];
            [_sapDelegate.managedObjectContext save:&error];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", error);
        }
        @finally {
            
            if(!error){
                
                [self filterLeaves];
                [self updateViews ];
            }
            else{
                
                if(!error){
                    
                    if(_isDeclinedSelected){
                        [self showPanelBarWithMessage:YES msg:@"Request has been declined successfully"];
                    }
                    else{
                        [self showPanelBarWithMessage:YES msg:@"Request has been declined successfully and moved into Declined panel"];
                    }
                    
                    [self filterLeaves];
                    [self updateViews ];
                }
                else{
                    
                    [self showPanelBarWithMessage:NO msg:@"Request decline failed"];
                }
            }
        }
    }
}

- (void) filterLeaves {
    
    [_lstFilterLeave removeAllObjects];        
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
    
    if(_lstFilterLeave.count > 0){
        _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    else{
        _selectedIndexPath = nil;
    }
}

// you have to update the view also have to change the side vise fileds accordingly
- (void) updateViews {
    
    [_tblLeave reloadData];
    [self updateLeaveApprovalDetail];
    
}

- (void) updateLeaveApprovalDetail{
    
    if(_selectedIndexPath && _selectedIndexPath.row >= 0){
        
        HR_leaves *leaveObj = [_lstFilterLeave objectAtIndex:_selectedIndexPath.row];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateStyle:NSDateFormatterMediumStyle];
        
        NSTimeInterval distanceBetweenDates = [leaveObj.to_date timeIntervalSinceDate:leaveObj.from_date];
        double secondsInDay = 60*60*24;
        NSInteger dayBetweenDates = distanceBetweenDates / secondsInDay;
        
        // fetch record for department name
        NSPredicate * predicate = [NSPredicate predicateWithFormat: @"(dept_id = %@)", leaveObj.dept_id];
        NSArray *lstDepartment = [self fetchDataFromCoreDataWithPredicate:predicate AndEntityName:@"Departments"];
        
        [_btnEmployeeID setTitle:leaveObj.emp_number forState:UIControlStateNormal & UIControlStateSelected];
        [_btnEmployeeName setTitle:leaveObj.emp_name forState:UIControlStateNormal & UIControlStateSelected];
        [_btnDepartment setTitle:[(Departments *)[lstDepartment objectAtIndex:0] dept_name] forState:UIControlStateNormal & UIControlStateSelected];
        [_btnDuration setTitle:[NSString stringWithFormat:@"%d Day(s)", dayBetweenDates] forState:UIControlStateNormal & UIControlStateSelected];
        [_btnAppliedDate setTitle:[format stringFromDate:leaveObj.applied_date] forState:UIControlStateNormal & UIControlStateSelected];
        [_btnFromDate setTitle:[format stringFromDate:leaveObj.from_date] forState:UIControlStateNormal & UIControlStateSelected];
        [_btnToDate setTitle:[format stringFromDate:leaveObj.to_date] forState:UIControlStateNormal & UIControlStateSelected];
        [_btnLeaveType setTitle:leaveObj.leave_type forState:UIControlStateNormal & UIControlStateSelected];
        [_tvNotes setText:leaveObj.notes];
        
        if([leaveObj.isProcessed isEqualToNumber:[NSNumber numberWithBool:NO]]){
            
            [_btnApprove setEnabled:YES];
            [_btnDecline setEnabled:YES];
        }
        else{
            
            [_btnApprove setEnabled:NO];
            [_btnDecline setEnabled:NO];
        }
    }
    else{
     
        [_btnEmployeeID     setTitle:@"" forState:UIControlStateNormal & UIControlStateSelected];
        [_btnEmployeeName   setTitle:@"" forState:UIControlStateNormal & UIControlStateSelected];
        [_btnDepartment     setTitle:@"" forState:UIControlStateNormal & UIControlStateSelected];
        [_btnDuration       setTitle:@"" forState:UIControlStateNormal & UIControlStateSelected];
        [_btnAppliedDate    setTitle:@"" forState:UIControlStateNormal & UIControlStateSelected];
        [_btnFromDate       setTitle:@"" forState:UIControlStateNormal & UIControlStateSelected];
        [_btnToDate         setTitle:@"" forState:UIControlStateNormal & UIControlStateSelected];
        [_btnLeaveType      setTitle:@"" forState:UIControlStateNormal & UIControlStateSelected];
        [_tvNotes           setText:@""];
        
        [_btnApprove setEnabled:NO];
        [_btnDecline setEnabled:NO];
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
    return 142.0f;
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
    UILabel *lblName, *lblFromDate, *lbltoDate, *lblDuration, *lblReason;
    UIImageView *imgViewBackground, *imgViewCalender, *imgViewStatus;
    UIView *vwSeperatorUpper, *vwSeperatorLower;
    
    cell = [tableView dequeueReusableCellWithIdentifier:branchCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil] objectAtIndex:2];
        
    }
    
    imgViewBackground = (UIImageView *)[cell.contentView viewWithTag:10];
    imgViewCalender = (UIImageView *)[cell.contentView viewWithTag:40];
    imgViewStatus = (UIImageView *)[cell.contentView viewWithTag:110];
    
    vwSeperatorUpper = (UIView *)[cell.contentView viewWithTag:30];
    vwSeperatorLower = (UIView *)[cell.contentView viewWithTag:80];
    
    
    lblName = (UILabel *)[cell.contentView viewWithTag:20];
    lblFromDate = (UILabel *)[cell.contentView viewWithTag:50];
    lbltoDate = (UILabel *)[cell.contentView viewWithTag:70];
    lblDuration = (UILabel *)[cell.contentView viewWithTag:90];
    lblReason = (UILabel *)[cell.contentView viewWithTag:100];
    
    // to round label
    [[lblDuration layer] setCornerRadius:3.0];
    
    if(_selectedIndexPath && _selectedIndexPath.row == indexPath.row){
        
        [cell setFrame:CGRectMake(0, 0, 275, 142)];
        [imgViewBackground setFrame:CGRectMake(0, 10, 275, 122)];
        [vwSeperatorUpper setFrame:CGRectMake(5, 48, 250, 1)];
        [vwSeperatorLower setFrame:CGRectMake(5, 86, 250, 1)];
        [imgViewBackground setImage:[UIImage imageNamed:@"DataBoxHover"]];
        [imgViewCalender setImage:[UIImage imageNamed:@"cal3"]];
        [lblFromDate setTextColor:[UIColor whiteColor]];
        [lbltoDate setTextColor:[UIColor whiteColor]];
        [lblReason setTextColor:[UIColor whiteColor]];
    }
    else{
        [cell setFrame:CGRectMake(0, 0, 270, 142)];
        [imgViewBackground setFrame:CGRectMake(0, 10, 270, 122)];
        [vwSeperatorLower setFrame:CGRectMake(5, 48, 245, 1)];
        [vwSeperatorLower setFrame:CGRectMake(5, 86, 245, 1)];
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
    
    lblName.text = leaveObj.emp_name;
    lblFromDate.text = [format stringFromDate:leaveObj.from_date];
    lbltoDate.text = [format stringFromDate:leaveObj.to_date];
    lblReason.text = leaveObj.leave_type;
    lblDuration.text = [NSString stringWithFormat:@"%d Days", dayBetweenDates];
    
    
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    _selectedIndexPath = indexPath;
    [self updateViews];
    
}


@end
