
//
//  MyTableViewController.m
//  Sample Storyboard
//
//  Created by Peter Paulis on 1.4.2013.
//  Copyright (c) 2013 Min60 s.r.o. - http://min60.com. All rights reserved.
//

#import "MyTableViewController.h"
#import "M6ParallaxController.h"
#import "MHInteractionCell.h"


@interface MyTableViewController ()

@end

@implementation MyTableViewController

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.parallaxController tableViewControllerDidScroll:self];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
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
    
}





@end
