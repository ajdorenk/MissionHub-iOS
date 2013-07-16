//
//  MHInitiatorCell.m
//  MissionHub
//
//  Created by Amarisa Robison on 7/15/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHInitiatorCell.h"

@implementation MHInitiatorCell

@synthesize name;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
    }
    return self;
    
}

- (void)awakeFromNib{
    self.name.font = [UIFont fontWithName:@"Arial" size:15.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)populateWithInitiator:(MHPerson *)person{
    self.name.text = [person fullName];
}

@end
