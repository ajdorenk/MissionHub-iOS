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
#import "MHInfoHeaderCell.h"
#import "MHInfoCell.h"
#import "MHAddressCell.h"

CGFloat const MHProfileInfoViewControllerHeaderCellHeight	= 21.0;
CGFloat const MHProfileInfoViewControllerInfoCellHeight		= 44.0;
CGFloat const MHProfileInfoViewControllerHeaderCellMargin	= 10.0;

@interface MHProfileInfoViewController ()

@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, strong) NSMutableArray *sections;

@end

@implementation MHProfileInfoViewController

@synthesize person			= _person;
@synthesize sectionTitles	= _sectionTitles;
@synthesize sections		= _sections;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
    [self.parallaxController tableViewControllerDidScroll:self];
	
}

-(void)awakeFromNib {
	
	[super awakeFromNib];
	self.tableView.userInteractionEnabled = YES;
	self.tableView.allowsSelection = YES;
	self.sectionTitles = [NSMutableArray array];
	self.sections = [NSMutableArray array];
	
	if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	
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


}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	//[self.tableView setContentOffset:CGPointZero animated:NO];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPerson:(MHPerson *)person {

	[self willChangeValueForKey:@"person"];
	_person = person;
	[self didChangeValueForKey:@"person"];
	
	if (person) {
		
		NSString		*gender = @"";
		NSString		*followupStatus = @"";
		NSMutableArray	*sectionTitles = [NSMutableArray array];
		NSMutableArray	*sections = [NSMutableArray array];
		NSMutableArray	*emailAddresses = [NSMutableArray array];
		NSMutableArray	*phoneNumbers = [NSMutableArray array];
		NSMutableArray	*addresses = [NSMutableArray array];
		
		if (person.gender) {
			gender = person.gender;
			[sectionTitles addObject:@"Gender"];
			[sections addObject:@[gender]];
		}
		
		if ([[person followupStatus] length] > 0) {
			followupStatus = [person followupStatus];
			[sectionTitles addObject:@"Status"];
			[sections addObject:@[followupStatus]];
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
	
    return [[self.sections objectAtIndex:section] count] + 1;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//	
//	UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//	
//	header.backgroundColor	= [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
//	header.text				= [self.sectionTitles objectAtIndex:section];
//	header.textColor		= [UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:1.0];
//	header.font				= [UIFont fontWithName:@"HelveticaNeue" size:14.0];
//	
//	return header;
//	
//}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
	return 0.0f;
	
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) {
		return 21.0f;
	} else {
		
		id objectForCell = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - 1];
		
		if ([objectForCell isKindOfClass:[MHAddress class]]) {
			
			return [MHAddressCell heightForCellWithAddress:(MHAddress *)objectForCell andWidth:CGRectGetWidth(self.tableView.frame)];
			
		} else {
			
			return 44.0f;
			
		}
	}
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"MHInfoCell";
	MHInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	// Configure the cell...
	if (cell == nil) {
		cell = [[MHInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	if (indexPath.row == 0) {
		
		static NSString *CellIdentifier = @"MHInfoHeaderCell";
		MHInfoHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		// Configure the cell...
		if (headerCell == nil) {
			headerCell = [[MHInfoHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		
		id objectForCell = [self.sectionTitles objectAtIndex:indexPath.section];
		NSString *cellText = @"";
		
		if ([objectForCell isKindOfClass:[NSString class]]) {
			cellText = objectForCell;
		}
		
		headerCell.text = cellText;
		
		return headerCell;
		
	} else {
		
		id objectForCell = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - 1];
		NSString *cellText = @"";
		
		if ([objectForCell isKindOfClass:[NSString class]]) {
			
			cellText = objectForCell;
			
		} else if ([objectForCell isKindOfClass:[MHEmailAddress class]]) {
			
			cellText = [(MHEmailAddress *)objectForCell email];
			
		} else if ([objectForCell isKindOfClass:[MHPhoneNumber class]]) {
			
			cellText = [(MHPhoneNumber *)objectForCell number];
			
		} else if ([objectForCell isKindOfClass:[MHAddress class]]) {
			
			static NSString *addressCellIdentifier = @"MHAddressCell";
			MHAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:addressCellIdentifier];
			
			// Configure the cell...
			if (addressCell == nil) {
				addressCell = [[MHAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addressCellIdentifier];
			}
			
			addressCell.address = (MHAddress *)objectForCell;
			
			return addressCell;
			
		}
		
		cell.text		= cellText;
		
	}
	
    return cell;
	
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.row > 0) {
	
		id objectForCell				= [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - 1];
		NSArray *activityItems			= @[];
		
		if ([objectForCell isKindOfClass:[MHEmailAddress class]]) {
			
			MHEmailAddress *email		= (MHEmailAddress *)objectForCell;
			
			activityItems				= @[email];
			
		} else if ([objectForCell isKindOfClass:[MHPhoneNumber class]]) {
			
			MHPhoneNumber *phoneNumber	= (MHPhoneNumber *)objectForCell;
			
			activityItems				= @[phoneNumber];
			
//			NSString *phoneNumber = [(MHPhoneNumber *)objectForCell number];
//			NSString *cleanedString = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
//			NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedString]];
//			
//			[[UIApplication sharedApplication] openURL:telURL];
			
		} else if ([objectForCell isKindOfClass:[MHAddress class]]) {
			
			MHAddress *address			= (MHAddress *)objectForCell;
			
			activityItems				= @[address];
			
		} else {
			
			activityItems				= @[self.person];
			
		}
		
		//TODO: Launch menu
		
	}
	
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Mail cancelled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Mail saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Mail sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Mail sent failure: %@", [error localizedDescription]);
			break;
		default:
			break;
	}
	
	// Close the Mail Interface
	[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
