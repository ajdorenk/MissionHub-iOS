//
//  MHGenderListController.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/24/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//


#import "MHGenderListController.h"
#import "MHPeopleListViewController.h"  

@interface MHGenderListController ()


@end

@implementation MHGenderListController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
    
   /* self.genderToolbar.layer.borderWidth = 2.0f;
    self.genderToolbar.layer.borderColor= [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1].CGColor;
    */
    
    self.genderListCells.layer.borderWidth = 1.0f;
    self.genderListCells.layer.borderColor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1].CGColor;
    
}
- (void)awakeFromNib
{
        self.genders = [NSArray arrayWithObjects:@"Male", @"Female", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view



   }
- (IBAction)donePressed:(id)sender {
 // configure the new view controller explicitly here.
    [self dismissViewControllerAnimated:NO completion:Nil];

}
/*- (IBAction)cancelPressed:(id)sender {
 [self dismissViewControllerAnimated:NO completion:Nil];
}
*/


#pragma mark - Table view data source

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.genders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //static
    NSString *CellIdentifier = @"genderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //Display person in the table cell
    //NSString *tempString = [self.genders objectAtIndex:indexPath.row];
    cell.textLabel.text = [self.genders objectAtIndex:indexPath.row];
    
    return cell;
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        [self performSegueWithIdentifier:@"MHSublabel" sender:self];
    }
    
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
