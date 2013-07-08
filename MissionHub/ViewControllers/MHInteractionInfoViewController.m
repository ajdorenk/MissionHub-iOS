//
//  MHInteractionInfoViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 7/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHInteractionInfoViewController.h"
#import "M6ParallaxController.h"
#import "MHInteractionCell.h"

@interface MHInteractionInfoViewController ()

@end

@implementation MHInteractionInfoViewController


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.parallaxController tableViewControllerDidScroll:self];
    
}

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
 // Return the number of sections.
 return 1;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 // Return the number of rows in the section.
 return 10;
 }
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 
 static NSString *CellIdentifier = @"InteractionCell";
 MHInteractionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 // Configure the cell...
 if (cell == nil) {
 cell = [[MHInteractionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 
 return cell;
 
 }*/

@end
