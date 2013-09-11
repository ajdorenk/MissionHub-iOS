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

@synthesize cellDelegate	= _cellDelegate;
@synthesize person			= _person;
@synthesize indexPath		= _indexPath;
@synthesize fieldName		= _fieldName;
@synthesize field, name, profilePicture, checkbox, nameBackgroundView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		[self configure];

    }
    return self;
}


-(void)awakeFromNib {
    
	[super awakeFromNib];
	
	[self configure];
    
}

- (void)configure {
	
//	self.imageView.frame						= CGRectMake(40, 7, 45, 45);
//	self.imageView.contentMode					= UIViewContentModeScaleAspectFill;
//	self.textLabel.frame						= CGRectMake(100, 10, 220, 26);
//	self.textLabel.textColor					= [UIColor colorWithRed:128.0/255.0 green:130.0/255.0 blue:132.0/255.0 alpha:1.0];
//	self.textLabel.font							= [UIFont fontWithName:@"ArialRoundedMTBold" size:15.0];
//	self.detailTextLabel.frame					= CGRectMake(120, 32, 200, 26);
//	self.detailTextLabel.font					= [UIFont fontWithName:@"ArialMT" size:14.0];
//	self.detailTextLabel.textColor				= [UIColor colorWithRed:128.0/255.0 green:130.0/255.0 blue:132.0/255.0 alpha:1.0];
    self.nameBackgroundView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.nameBackgroundView.layer.borderWidth = 1.0;
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.nameBackgroundView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    }
	
	self.checkbox.checkboxDelegate = self;
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)populateWithPerson:(MHPerson *)person forField:(MHPersonSortFields)sortField withSelection:(BOOL)selected atIndexPath:(NSIndexPath *)indexPath {
    
	self.person		= person;
	self.indexPath	= indexPath;
	
    if (person.picture == nil) {
		
        self.profilePicture.image = [UIImage imageNamed:@"MHPersonCell_Placeholder.png"];
        
    } else {
		
        [self.profilePicture setImageWithURL:[NSURL URLWithString:person.picture]
					   placeholderImage:[UIImage imageNamed:@"MHPersonCell_Placeholder.png"]];
    }
    
	self.field.text = [person valueForSortField:sortField];

    self.name.text = [person fullName];
	
	self.checkbox.selected = selected;
	
}

-(void)checkbox:(MHCheckbox *)checkbox didChangeValue:(BOOL)checked {
	
	if (checked) {
		
		if ([self.cellDelegate respondsToSelector:@selector(cell:didSelectPerson:atIndexPath:)]) {
			
			[self.cellDelegate cell:self didSelectPerson:self.person atIndexPath:self.indexPath];
			
		}
		
	} else {
		
		if ([self.cellDelegate respondsToSelector:@selector(cell:didDeselectPerson:atIndexPath:)]) {
			
			[self.cellDelegate cell:self didDeselectPerson:self.person atIndexPath:self.indexPath];
			
		}
		
	}
	
	
	
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	self.nameBackgroundView.frame	= CGRectMake(CGRectGetMinX(self.nameBackgroundView.frame),
												 CGRectGetMinY(self.nameBackgroundView.frame),
												 CGRectGetWidth(self.frame) - CGRectGetMinX(self.nameBackgroundView.frame) + 1,
												 CGRectGetHeight(self.nameBackgroundView.frame));
	
	self.field.frame	= CGRectMake(CGRectGetMinX(self.field.frame),
												 CGRectGetMinY(self.field.frame),
												 CGRectGetWidth(self.frame) - CGRectGetMinX(self.field.frame),
												 CGRectGetHeight(self.field.frame));
	
}

@end
