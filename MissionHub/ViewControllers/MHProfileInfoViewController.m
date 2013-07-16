//
//  MHProfileInfoViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 7/12/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHProfileInfoViewController.h"
#import "M6ParallaxController.h"
#import "MHPerson+Helper.h"
#import "MHAddress+Helper.h"

@interface MHProfileInfoViewController ()

@end

@implementation MHProfileInfoViewController

@synthesize gender = _gender;
@synthesize followupStatus = _followupStatus;
@synthesize emailAddresses = _emailAddresses;
@synthesize phoneNumbers = _phoneNumbers;
@synthesize addresses = _addresses;

@synthesize sectionTitles = _sectionTitles;
@synthesize sections = _sections;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
    [self.parallaxController tableViewControllerDidScroll:self];
	
}

-(void)awakeFromNib {
	
	[super awakeFromNib];
	
	self.gender = @"";
	self.followupStatus = @"";
	self.emailAddresses = [NSMutableArray array];
	self.phoneNumbers = [NSMutableArray array];
	self.addresses = [NSMutableArray array];
	
	self.sectionTitles = [NSMutableArray array];
	self.sections = [NSMutableArray array];
	
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    UIImageView *infoDemoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"InfoDemo.png"]];
    
    // Your scroll view or table view would be a subview of this view
    [self.tableView addSubview:infoDemoView];
    [self.tableView bringSubviewToFront:infoDemoView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setPerson:(MHPerson *)person {
	/*
	if (person) {
		
		NSMutableArray *sectionTitles = [NSMutableArray array];
		NSMutableArray *sections = [NSMutableArray array];
		NSMutableArray *emailAddresses = [NSMutableArray array];
		NSMutableArray *phoneNumbers = [NSMutableArray array];
		NSMutableArray *addresses = [NSMutableArray array];
		
		if (person.gender) {
			self.gender = person.gender;
			[sectionTitles addObject:@"Gender"];
			[sections addObject:@[self.gender]];
		}
		
		if ([[person followupStatus] length] > 0) {
			self.followupStatus = [person followupStatus];
			[sectionTitles addObject:@"Status"];
			[sections addObject:@[self.followupStatus]];
		}
		
		if ([person.emailAddresses count] > 0) {
			
			[person.emailAddresses enumerateObjectsUsingBlock:^(id emailAddress, BOOL *stop) {
				if ([emailAddress isKindOfClass:[MHEmailAddress class]]) {
					if ([[emailAddress email] length]) {
						
						[emailAddresses addObject:emailAddress];
						
					}
				}
			}];
			
			if ([emailAddresses count] > 0) {
				
				[sectionTitles addObject:@"Email Addresses"];
				[sections addObject:emailAddresses];
				
			}
			
		}
		
		if ([person.phoneNumbers count] > 0) {
			
			[person.phoneNumbers enumerateObjectsUsingBlock:^(id phoneNumber, BOOL *stop) {
				if ([phoneNumber isKindOfClass:[MHPhoneNumber class]]) {
					if ([[phoneNumber number] length]) {
						
						[phoneNumbers addObject:phoneNumber];
						
					}
				}
			}];
			
			if ([phoneNumbers count] > 0) {
				
				[sectionTitles addObject:@"Phone Numbers"];
				[sections addObject:phoneNumbers];
				
			}
			
		}
		
		if ([person.addresses count] > 0) {
			
			[person.addresses enumerateObjectsUsingBlock:^(id address, BOOL *stop) {
				if ([address isKindOfClass:[MHAddress class]]) {
					if ([[address displayString] length]) {
						
						[addresses addObject:address];
						
					}
				}
			}];
			
			if ([addresses count] > 0) {
				
				[sectionTitles addObject:@"Addresses"];
				[sections addObject:addresses];
				
			}
			
		}
		
		if ([sections count] == 0) {
			
			[sectionTitles addObject:@"Sorry No Info Available"];
			[sections addObject:@[@"Please add more!"]];
			
		}
		
		self.sectionTitles = sectionTitles;
		self.sections = sections;
		
		[self.tableView reloadData];
		
	}
	*/
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	
    return [[self.sections objectAtIndex:section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
	
	header.backgroundColor	= [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
	header.text				= [self.sectionTitles objectAtIndex:section];
	header.textColor		= [UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:1.0];
	header.font				= [UIFont fontWithName:@"HelveticaNeue" size:14.0];
	
	return header;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"InfoCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	// Configure the cell...
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	id objectForCell = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	NSString *cellText = @"";
	
	if ([objectForCell isKindOfClass:[NSString class]]) {
		cellText = objectForCell;
	} else if ([objectForCell isKindOfClass:[MHEmailAddress class]]) {
		cellText = [(MHEmailAddress *)objectForCell email];
	} else if ([objectForCell isKindOfClass:[MHPhoneNumber class]]) {
		cellText = [(MHPhoneNumber *)objectForCell number];
	} else if ([objectForCell isKindOfClass:[MHAddress class]]) {
		cellText = [(MHAddress *)objectForCell displayString];
	}
	
	cell.textLabel.text = cellText;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	
	
}

@end
