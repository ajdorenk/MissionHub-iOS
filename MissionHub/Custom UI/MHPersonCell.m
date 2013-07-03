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

@synthesize name, gender, profilePicture, checkbox, nameBackgroundView;

//@synthesize delegate;
//@synthesize allRoles, selectedRoles, originallySelectedRoles;
//@synthesize applyButton;
//@synthesize tableView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code


    }
    return self;
}

-(void)awakeFromNib {
    
    self.nameBackgroundView.layer.borderColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0].CGColor;
    self.nameBackgroundView.layer.borderWidth = 1.0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)populateCell:(MHPersonCell *)personCell withPerson:(MHPerson *)person{
//    person *person = [self.persons objectAtIndex:indexPath.row];
    
    if (personCell.profilePicture.image == nil)
    {
        personCell.profilePicture.image = [UIImage imageNamed:@"fb_blank_profile_square.png"];
        
    } else {
        [personCell.profilePicture setImageWithURL:[NSURL URLWithString:person.picture]
													  placeholderImage:[UIImage imageNamed:@"fb_blank_profile_square.png"]];
    }
    
    personCell.gender.text = person.gender;
    personCell.name.text = [person fullName];
}

@end
