//
//  MHPerson.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/13/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHPersonCell.h"
#import "UIImageView+AFNetworking.h"


@implementation MHPersonCell

@synthesize name, gender, profilePicture, checkButton, nameBackgroundView;

//@synthesize delegate;
//@synthesize allRoles, selectedRoles, originallySelectedRoles;
//@synthesize applyButton;
//@synthesize tableView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.nameBackgroundView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
        self.nameBackgroundView.layer.borderWidth = 1.0;

    }
    return self;
}


-(void)awakeFromNib {
    
    self.nameBackgroundView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.nameBackgroundView.layer.borderWidth = 1.0;
    
   // UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *uncheckedBox = [UIImage imageNamed:@"MH_Mobile_Checkbox_Unchecked_24.png"];
    [checkButton setFrame:CGRectMake(13.0, 9.0, 15.0, 15.0)];
    [checkButton setTintColor:[UIColor clearColor]];
    [checkButton setBackgroundImage:uncheckedBox forState:UIControlStateNormal];
    [checkButton setBackgroundColor:[UIColor clearColor]];
    [checkButton addTarget:self action:@selector(checkContact:) forControlEvents:UIControlEventTouchDown];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)checkContact:(UIButton*)button {
    NSLog(@"Check all");
    button.selected = !button.selected;
    
    if (button.selected) {
        UIImage *checkedBox = [UIImage imageNamed:@"MH_Mobile_Checkbox_Checked_24.png"];
        [button setFrame:CGRectMake(13.0, 5.0, 18, 19)];
        [button setBackgroundImage:checkedBox forState:UIControlStateNormal];
    }
    else{
        UIImage *uncheckedBox = [UIImage imageNamed:@"MH_Mobile_Checkbox_Unchecked_24.png"];
        [button setFrame:CGRectMake(13.0, 9.0, 15, 15)];
        [button setBackgroundImage:uncheckedBox forState:UIControlStateNormal];
        
    }
}


-(void)populateWithPerson:(MHPerson *)person{
//    person *person = [self.persons objectAtIndex:indexPath.row];
    
    if (self.profilePicture.image == nil)
    {
        self.profilePicture.image = [UIImage imageNamed:@"MHPersonCell_Placeholder.png"];
        
    } else {
        [self.profilePicture setImageWithURL:[NSURL URLWithString:person.picture]
													  placeholderImage:[UIImage imageNamed:@"MHPersonCell_Placeholder.png"]];
    }
    
    self.gender.text = person.gender;
    self.name.text = [person fullName];
}

@end
