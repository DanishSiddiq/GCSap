//
//  HRLeaveApprovalView.m
//  sap
//
//  Created by goodcore2 on 6/20/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import "HRLeaveApprovalView.h"

@interface HRLeaveApprovalView ()

@property (retain, nonatomic) IBOutlet UIView *hrLeaveApproval;

@property (nonatomic, strong) AppDelegate *sapDelegate;
@property (retain, nonatomic) IBOutlet UITableView *tblLeave;
@property (retain, nonatomic) NSMutableArray *lstLeave;
@property (retain, nonatomic) NSMutableArray *lstFilterLeave;
@property (nonatomic) BOOL isApprovedSelected;
@property (nonatomic) BOOL isUnApprovedSelected;
@property (retain, nonatomic) NSIndexPath* selectedIndexPath;

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
        [self initializeViews:frame];
        [self initializeData:sapDelegate];
    }
    return self;
}


- (void) initializeViews : (CGRect) frame {
    
    frame.origin.y = 0;
    self.hrLeaveApproval.frame = frame;
    [self addSubview:self.hrLeaveApproval];
    
    [_tblLeave setShowsVerticalScrollIndicator:NO];
}


-(void) initializeData  : (AppDelegate *) sapDelegate{
    
    _sapDelegate = sapDelegate;
    _lstFilterLeave = [[NSMutableArray alloc] init];
    _lstLeave = [[NSMutableArray alloc] init];
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
- (IBAction)btnPressedApproved:(id)sender {
    
    _isApprovedSelected = !_isApprovedSelected;
    [(UIButton *)sender setImage:[UIImage imageNamed:_isApprovedSelected ? @"check2" : @"check"] forState:UIControlStateNormal];
    
    [self filterLeaves];
    [self updateViews ];
}

- (IBAction)btnPressedUnApproved:(id)sender {
    
    _isUnApprovedSelected = !_isUnApprovedSelected;
    [(UIButton *)sender setImage:[UIImage imageNamed:_isUnApprovedSelected ? @"check2" : @"check"] forState:UIControlStateNormal];
    
    [self filterLeaves];
    [self updateViews ];
}

- (void) filterLeaves {
    
    [_lstFilterLeave removeAllObjects];
        
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
    UIImageView *imgViewBackground, *imgViewCalender;
    UIView *vwSeperatorUpper, *vwSeperatorLower;
    
    cell = [tableView dequeueReusableCellWithIdentifier:branchCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil] objectAtIndex:2];
        
    }
    
    imgViewBackground = (UIImageView *)[cell.contentView viewWithTag:10];
    imgViewCalender = (UIImageView *)[cell.contentView viewWithTag:40];
    
    vwSeperatorUpper = (UIView *)[cell.contentView viewWithTag:30];
    vwSeperatorLower = (UIView *)[cell.contentView viewWithTag:80];
    
    
    lblName = (UILabel *)[cell.contentView viewWithTag:20];
    lblFromDate = (UILabel *)[cell.contentView viewWithTag:50];
    lbltoDate = (UILabel *)[cell.contentView viewWithTag:70];
    lblDuration = (UILabel *)[cell.contentView viewWithTag:90];
    lblReason = (UILabel *)[cell.contentView viewWithTag:100];
    
    // to round label
    [[lblDuration layer] setCornerRadius:3.0];
    
    if(_selectedIndexPath.row == indexPath.row){
        
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndexPath = indexPath;
    [_tblLeave reloadData];
    
}


@end
