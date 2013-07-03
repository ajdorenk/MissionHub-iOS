//
//  MHMenuViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 6/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHMenuViewController.h"
#import "MHAPI.h"
#import "MHLabel.h"
#import "MHPerson+Helper.h"
#import "MHSurvey.h"

@interface MHMenuViewController ()
@property (nonatomic, strong) MHPerson *user;
@property (nonatomic, strong) NSArray *menuHeaders;
@property (nonatomic, strong) NSMutableArray *menuItems;
@end

@implementation MHMenuViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib
{
	self.menuHeaders	= @[@"", @"LABELS", @"LEADERS", @"SURVEYS", @"SETTINGS"];
	self.menuItems		= [NSMutableArray arrayWithArray:@[@[@"ALL CONTACTS"],@[@"Loading..."],@[@"Loading..."],@[@"Loading..."],@[@"CHANGE ORGANIZATION", @"LOG OUT"]]];
	
	if ([MHAPI sharedInstance].currentUser) {
		
		[self setCurrentUser:[MHAPI sharedInstance].currentUser];
		
	}
	
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.slidingViewController setAnchorRightRevealAmount:280.0f];
	self.slidingViewController.underLeftWidthLayout = ECFullWidth;
	
}

-(id)setCurrentUser:(MHPerson *)currentUser {
	
	self.user = currentUser;
	
	if (currentUser.currentOrganization.labels) {
		
		NSArray *labelArray = [[currentUser.currentOrganization.labels allObjects]
							   sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name"
																						   ascending:YES
																							selector:@selector(caseInsensitiveCompare:)]]];
		
		[self.menuItems replaceObjectAtIndex:1 withObject:labelArray];
		
	} else {
		
		[self.menuItems replaceObjectAtIndex:1 withObject:@[]];
		
	}
	
	if (currentUser.currentOrganization.leaders) {
		
		NSArray *leaderArray = [[currentUser.currentOrganization.leaders allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"first_name" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
		
		[self.menuItems replaceObjectAtIndex:2 withObject:leaderArray];
		
	} else {
		
		[self.menuItems replaceObjectAtIndex:2 withObject:@[]];
		
	}
	
	if (currentUser.currentOrganization.surveys) {
		
		NSArray *surveyArray = [[currentUser.currentOrganization.surveys allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
		
		[self.menuItems replaceObjectAtIndex:3 withObject:surveyArray];
		
	} else {
		
		[self.menuItems replaceObjectAtIndex:3 withObject:@[]];
		
	}
	
	return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.menuHeaders count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
	
	header.backgroundColor	= [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
	header.text				= [self.menuHeaders objectAtIndex:section];
	header.textColor		= [UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:1.0];
	header.font				= [UIFont fontWithName:@"HelveticaNeue" size:14.0];
	
	return header;
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.menuItems objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//create cell
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
	
	//configure cell
	cell.textLabel.textColor    = [UIColor colorWithRed:(192.0/255.0) green:(192.0/255.0) blue:(192.0/255.0) alpha:1.0];
	cell.textLabel.font         = [UIFont fontWithName:@"ArialRoundedMTBold" size:14.0];
	
	//set cell value
	id objectForCell = [[self.menuItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	//grab the cell's text value based on the type of the object that was retreived
	if ([objectForCell isKindOfClass:[NSString class]]) {
		
		cell.textLabel.text = objectForCell;
		
	} else if ([objectForCell isKindOfClass:[MHLabel class]]) {
		
		cell.textLabel.text = ((MHLabel *)objectForCell).name;
		
	} else if ([objectForCell isKindOfClass:[MHPerson class]]) {
		
		cell.textLabel.text = [((MHPerson *)objectForCell) fullName];
		
	} else if ([objectForCell isKindOfClass:[MHSurvey class]]) {
		
		cell.textLabel.text = ((MHSurvey *)objectForCell).title;
		
	}
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if (indexPath.section == 4) {
		
		//call setting action
		
	}
	
	if (indexPath.section >= 0 && indexPath.section < 4) {
		
		NSString *identifier = @"PeopleList";
		
		if (indexPath.section == 3) {
			identifier = @"Survey";
		}
		
		UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
		
		[self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
			CGRect frame = self.slidingViewController.topViewController.view.frame;
			self.slidingViewController.topViewController = newTopViewController;
			self.slidingViewController.topViewController.view.frame = frame;
			[self.slidingViewController resetTopView];
		}];
		
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
