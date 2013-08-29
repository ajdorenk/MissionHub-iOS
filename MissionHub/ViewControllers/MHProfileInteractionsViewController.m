//
//  MHInteractionViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 7/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHProfileInteractionsViewController.h"
#import "M6ParallaxController.h"
#import "MHHeaderCell.h"
#import "MHInteractionCell.h"
#import "MHInteractionType.h"

@interface MHProfileInteractionsViewController ()

@end

@implementation MHProfileInteractionsViewController

@synthesize _person;
@synthesize _interactionArray;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
    [self.parallaxController tableViewControllerDidScroll:self];
	
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib {
	
	[super awakeFromNib];
	
	self._interactionArray = [NSMutableArray array];
	
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

-(void)setPerson:(MHPerson *)person {
	
	if (person) {
		
		self._person = person;
		[self._interactionArray removeAllObjects];
		[self._interactionArray addObjectsFromArray:[self._person.initiatedInteractions allObjects]];
		[self._interactionArray addObjectsFromArray:[self._person.receivedInteractions allObjects]];
		[self._interactionArray addObjectsFromArray:[self._person.updatedInteractions allObjects]];
		[self._interactionArray addObjectsFromArray:[self._person.createdInteractions allObjects]];
		[self._interactionArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES]]];
		
		[self.tableView reloadData];
		
	}
	
}

-(void)setInteractionArray:(NSMutableArray *)interactionArray {
	
	if (interactionArray) {
		
		[self willChangeValueForKey:@"interactionArray"];
		_interactionArray = interactionArray;
		[self didChangeValueForKey:@"interactionArray"];
		
		[self.tableView reloadData];
		
	}
	
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2 * [self._interactionArray count];
}

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
	
	if (indexPath.row % 2 == 0) {
		
		return MHHeaderCellHeight;
		
	} else {
	
		NSInteger interactionRow	= floor(indexPath.row / 2);
		MHInteraction *interaction = (MHInteraction *)([self._interactionArray objectAtIndex:interactionRow]);
		return [MHInteractionCell heightForCellWithInteraction:interaction];
		
	}
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *headerCellIdentifier		= @"MHHeaderCell";
	static NSString *interactionCellIdentifier	= @"MHInteractionsCell";
	
	if (indexPath.row % 2 == 0) {
	
		MHHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:headerCellIdentifier];
		
		// Configure the cell...
		if (cell == nil) {
			cell = [[MHHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellIdentifier];
		}
		
		// Configure the cell...
		NSInteger interactionRow	= floor(indexPath.row / 2);
		MHInteraction *interaction = (MHInteraction *)([self._interactionArray objectAtIndex:interactionRow]);
		[cell configureCellWithTitle:interaction.title andDate:interaction.timestampString forTableview:tableView];
		
		return cell;
		
	} else {
			
		MHInteractionCell *cell = [tableView dequeueReusableCellWithIdentifier:interactionCellIdentifier];
		
		// Configure the cell...
		if (cell == nil) {
			cell = [[MHInteractionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:interactionCellIdentifier];
		}
		
		// Configure the cell...
		NSInteger interactionRow	= floor(indexPath.row / 2);
		MHInteraction *interaction = (MHInteraction *)([self._interactionArray objectAtIndex:interactionRow]);
		cell.interaction = interaction;
		
		return cell;
			
	}
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger interactionRow	= floor(indexPath.row / 2);
	MHInteraction *interaction = (MHInteraction *)([self._interactionArray objectAtIndex:interactionRow]);
	
	NSLog(@"%@", [interaction jsonObject]);
	
}

@end
