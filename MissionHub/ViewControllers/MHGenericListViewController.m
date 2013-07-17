//
//  MHGenericListViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/25/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHGenericListViewController.h"
#import "MHPeopleListViewController.h"
#import "MHGenericCell.h"
#import "MHPerson+Helper.h"

#define ROW_HEIGHT 36.0f


@interface MHGenericListViewController ()

- (void)removeToolbar;

@end

@implementation MHGenericListViewController


@synthesize selectionDelegate       = _selectionDelegate;
@synthesize objectArray				= _objectArray;


- (void)awakeFromNib {
    [super awakeFromNib];
    self.objectArray = [NSMutableArray array];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
	MHPerson *person1 =[MHPerson newObjectFromFields:@{@"id":@1234,@"first_name":@"Shelby",
                        @"last_name":@"Clarke",
                        @"gender":@"Male",
                        @"year_in_school":@"Second Year",
                        @"major":@" Philosophy",
                        @"minor":@"Computer Science",
                        @"birth_date":@"1982-07-07",
                        @"date_became_christian":@"2000-01-01",
                        @"graduation_date":@"2010-01-07",
                        @"user_id":@12345,
                        @"fb_uid":@123456,
                        @"updated_at":@"2012-11-19T19:29:30:06:00",
                        @"created_at":@"2002-11-28T00:00:00:06:00"
                        }];

    
	MHPerson *person2 =[MHPerson newObjectFromFields:@{@"id":@1234,@"first_name":@"John",
                        @"last_name":@"Doe",
                        @"gender":@"Male",
                        @"year_in_school":@"Second Year",
                        @"major":@" Philosophy",
                        @"minor":@"Computer Science",
                        @"birth_date":@"1982-07-07",
                        @"date_became_christian":@"2000-01-01",
                        @"graduation_date":@"2010-01-07",
                        @"user_id":@12345,
                        @"fb_uid":@123456,
                        @"updated_at":@"2012-11-19T19:29:30:06:00",
                        @"created_at":@"2002-11-28T00:00:00:06:00"
                        }];

    
    
       
    self.objectArray = [NSArray arrayWithObjects:person1, person2, nil];
    */
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    
    
    UIImage* menuImage = [UIImage imageNamed:@"BackMenu_Icon.png"];
    UIButton *backMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [backMenu setImage:menuImage forState:UIControlStateNormal];
    [backMenu addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backMenuButton = [[UIBarButtonItem alloc] initWithCustomView:backMenu];
    
    self.navigationItem.leftBarButtonItem = backMenuButton;
    self.tableViewList.layer.borderWidth = 1.0;
    self.tableViewList.layer.borderColor = [[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] CGColor];
    
    //self.tableViewList.separatorColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
    
    /*UIToolbar *toolbar = [[UIToolbar alloc] init];
    self.genericToolbar = toolbar;
    self.genericToolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    NSMutableArray *toolbarButtons = [[NSMutableArray alloc] init];
    [toolbarButtons addObject:backMenuButton];
    [self.genericToolbar setItems:toolbarButtons animated:NO];
    [self.view addSubview:self.genericToolbar];
*/
}


-(void)setDataArray:(NSArray *)dataArray {
    
	self.objectArray = [NSMutableArray arrayWithArray:dataArray];
	//[self.tableViewList reloadData];
    
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
    return [self.objectArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MHGenericCell";
    MHGenericCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Configure the cell...

    if (cell == nil) {
        
        cell = [[MHGenericCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    }

    
    id object = [self.objectArray objectAtIndex:indexPath.row];
	
	if ([object isKindOfClass:[NSString class]]) {
		[cell populateWithString:object];
	} else if ([object isKindOfClass:[MHModel class]]) {
		[cell populateWithString:[(MHModel *)object displayString]];
	}
	
    return cell;
}



- (IBAction)backToMenu:(id)sender {
    //[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];

    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*- (void)removeToolbar{
    [self.genericToolbar removeFromSuperview];
}
*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.objectArray objectAtIndex:indexPath.row];
    
    if ([self.selectionDelegate respondsToSelector:@selector(list:didSelectObject:atIndexPath:)]) {
        [self.selectionDelegate list:self didSelectObject:object atIndexPath:indexPath];
    }
	
	[self.tableViewList deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
