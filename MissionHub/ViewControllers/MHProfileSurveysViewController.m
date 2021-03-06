//
//  MHProfileSurveysViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 7/15/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHProfileSurveysViewController.h"
#import "M6ParallaxController.h"
#import "MHHeaderCell.h"
#import "MHAnswerCell.h"
#import "MHAnswerSheet+Helper.h"
#import "MHAPI.h"
#import "MHSurvey+Helper.h"
#import "MHAnswer.h"

@interface MHProfileSurveysViewController ()

@property (nonatomic, strong) NSMutableArray *surveyArray;
@property (nonatomic, strong) NSMutableDictionary *answers;

- (void)configure;

@end

@implementation MHProfileSurveysViewController

@synthesize person			= _person;
@synthesize surveyArray		= _surveyArray;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
    [self.parallaxController tableViewControllerDidScroll:self];
	
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
		// Custom initialization
		[self configure];
		
    }
    return self;
}

- (void)awakeFromNib {
	
	[super awakeFromNib];
	
	[self configure];
	
}

- (void)configure {
	
	self.surveyArray	= [NSMutableArray array];
	self.answers		= [NSMutableDictionary dictionary];
	
	if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	
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
		
		[self willChangeValueForKey:@"person"];
		_person				= person;
		[self didChangeValueForKey:@"person"];
		
		self.surveyArray	= [person.answerSheets.allObjects mutableCopy];
		
		if (!self.surveyArray) {
			
			self.surveyArray = [NSMutableArray array];
			
		}
		
		[self.surveyArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"updated_at" ascending:NO]]];
		self.answers = [NSMutableDictionary dictionary];
		
		for (MHAnswerSheet *answerSheet in self.surveyArray) {
			
			self.answers[answerSheet.survey_id] = [answerSheet.answers sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"question_id" ascending:YES]]];
			
		}
		
		[self.tableView reloadData];
		
	}
	
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.surveyArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	
	if ([self.surveyArray count] == 0) {
		return 0;
	}
	
	MHAnswerSheet *survey = [self.surveyArray objectAtIndex:section];
    return 1 + [self.answers[survey.survey_id] count];
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
	
	if (indexPath.row == 0) {
		
		return MHHeaderCellHeight;
		
	} else {
		
		MHAnswerSheet *survey	= [self.surveyArray objectAtIndex:indexPath.section];
		MHAnswer *answer		= [self.answers[survey.survey_id] objectAtIndex:indexPath.row - 1];
		return [MHAnswerCell heightForCellWithAnswer:answer andWidth:CGRectGetWidth(self.tableView.frame)];
		
	}
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *headerCellIdentifier	= @"MHHeaderCell";
	static NSString *surveyCellIdentifier	= @"MHAnswerCell";
	
	if (indexPath.row == 0) {
		
		MHHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:headerCellIdentifier];
		
		// Configure the cell...
		if (cell == nil) {
			cell = [[MHHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellIdentifier];
		}
		
		// Configure the cell...
		MHAnswerSheet *answerSheet	= [self.surveyArray objectAtIndex:indexPath.section];
		MHSurvey *survey = [[MHAPI sharedInstance].currentOrganization.surveys findWithRemoteID:answerSheet.survey_id];
		[cell configureCellWithTitle:survey.title andDate:answerSheet.updatedAtString forTableview:tableView];
		
		return cell;
		
	} else {
		
		MHAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:surveyCellIdentifier];
		
		// Configure the cell...
		if (cell == nil) {
			cell = [[MHAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:surveyCellIdentifier];
		}
		
		// Configure the cell...
		MHAnswerSheet *survey	= [self.surveyArray objectAtIndex:indexPath.section];
		MHAnswer *answer		= [self.answers[survey.survey_id] objectAtIndex:indexPath.row - 1];
		cell.answer				= answer;
		
		return cell;
		
	}
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	
	
}

@end
