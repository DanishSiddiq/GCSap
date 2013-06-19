//
//  HRView.m
//  sap
//
//  Created by goodcore1 on 6/14/13.
//  Copyright (c) 2013 goodcore1. All rights reserved.
//

#import "HRView.h"

@interface HRView()

@property (nonatomic, strong) AppDelegate *sapDelegate;
@property (retain, nonatomic) IBOutlet UIView* hrView;
@property (retain, nonatomic) IBOutlet UISwitch* switchApproved;
@property (retain, nonatomic) NSMutableArray* lstLeave;

@end

@implementation HRView

- (id)initWithFrame:(CGRect)frame sapDelegate : (AppDelegate *) sapDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"HRView" owner:self options:nil];
        [self initializeViews:frame];
        [self initializeData:sapDelegate];
        
    }
    return self;
}


- (void) initializeViews : (CGRect) frame {
    
    
    self.hrView.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
    [self addSubview:self.hrView];
}

-(void) initializeData  : (AppDelegate *) sapDelegate{
    
    _sapDelegate = sapDelegate;
    _lstLeave = [[NSMutableArray alloc] init];
    
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
    
}

// selectors
- (IBAction)slideBtnPressed:(id)sender {
 
    if(self.frame.origin.x == 120){
        
        CGRect toFrame = self.frame;
        toFrame.origin.x = 0.0;
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = toFrame;
        } completion:nil];
    }
    else{
        
        CGRect toFrame = self.frame;
        toFrame.origin.x = 120;
        
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = toFrame;
        } completion:nil];
    }
}

// switch delegate
- (IBAction)switchApprovedValueChanged:(id)sender {
}

#pragma searchbar delegates
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    // changing text logic here
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    // saerc logic will go here
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar setText:@""];
    [searchBar resignFirstResponder];
}

// delegates
#pragma table delagtes
#pragma sale table delagates
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [_lstLeave count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
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
    
    cell = [tableView dequeueReusableCellWithIdentifier:branchCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil] objectAtIndex:1];
        
    }
        
    lblFromDate = (UILabel *)[cell.contentView viewWithTag:10];
    lbltoDate = (UILabel *)[cell.contentView viewWithTag:20];
    lblDuration = (UILabel *)[cell.contentView viewWithTag:30];
    lblReason = (UILabel *)[cell.contentView viewWithTag:40];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}




@end
