//
//  MHMenuViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 6/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHMenuViewController.h"

@interface MHMenuViewController ()
@property (nonatomic, strong) NSArray *menuHeaders;
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
	self.menuHeaders = @[@"LABELS", @"LEADERS", @"Surveys", @"Settings"];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.slidingViewController setAnchorRightRevealAmount:280.0f];
	self.slidingViewController.underLeftWidthLayout = ECFullWidth;
	
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
    return ( section == 0 ? 2 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
	
	if (indexPath.row == 0) {
		cell.textLabel.text         = @"Label 1";
        cell.textLabel.textColor    = [UIColor colorWithRed:(192.0/255.0) green:(192.0/255.0) blue:(192.0/255.0) alpha:1.0];
        cell.textLabel.font         = [UIFont fontWithName:@"ArialRoundedMTBold" size:14.0];
	}
	
	if (indexPath.row == 1) {
		cell.textLabel.text         = @"Label 2";
        cell.textLabel.textColor    = [UIColor colorWithRed:(192.0/255.0) green:(192.0/255.0) blue:(192.0/255.0) alpha:1.0];
        cell.textLabel.font         = [UIFont fontWithName:@"ArialRoundedMTBold" size:14.0];
	}
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	NSString *identifier = @"PeopleList";
	
	if (indexPath.row == 0) {
		identifier = @"Survey";
	}
	
	UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
	
	[self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
		CGRect frame = self.slidingViewController.topViewController.view.frame;
		self.slidingViewController.topViewController = newTopViewController;
		self.slidingViewController.topViewController.view.frame = frame;
		[self.slidingViewController resetTopView];
	}];
	
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
