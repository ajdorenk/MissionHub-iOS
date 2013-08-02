//
//  MHGenericCell.m
//  MissionHub
//
//  Created by Michael Harrison on 7/15/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHGenericCell.h"

@implementation MHGenericCell

@synthesize label, checkmark;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		
		self.textLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:15];
		self.textLabel.textColor = [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
		
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
	if (selected) {
		
		self.checkmark.image = [UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark_24.png"];
		
	} else {
		
		self.checkmark.image = [UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_No_Checkmark_24.png"];
		
	}
	
}

-(void)populateWithString:(NSString *)text andSelected:(BOOL)selected {
	self.textLabel.text = text;
	self.selected		= selected;
}

@end
