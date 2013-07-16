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
    [checkbox setFrame:CGRectMake(13.0, 9.0, 15.0, 15.0)];
    [checkbox setTintColor:[UIColor clearColor]];
    [checkbox setBackgroundImage:uncheckedBox forState:UIControlStateNormal];
    [checkbox setBackgroundColor:[UIColor clearColor]];
    [checkbox addTarget:self action:@selector(checkContact:) forControlEvents:UIControlEventTouchDown];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)populateWithPerson:(MHPerson *)person forField:(MHPersonSortFields)sortField atIndexPath:(NSIndexPath *)indexPath {
    
	self.indexPath = indexPath;
	
    if (person.picture == nil) {
		
        self.profilePicture.image = [UIImage imageNamed:@"MHPersonCell_Placeholder.png"];
        
    } else {
		
        [self.profilePicture setImageWithURL:[NSURL URLWithString:person.picture]
													  placeholderImage:[UIImage imageNamed:@"MHPersonCell_Placeholder.png"]];
    }
    
	self.gender.text = [person valueForSortField:sortField];

    self.name.text = [person fullName];
	
}

-(void)checkbox:(MHCheckbox *)checkbox didChangeValue:(BOOL)checked {
	
	if ([self.cellDelegate respondsToSelector:@selector(cell:didSelectPerson:atIndexPath:)]) {
		
		[self.cellDelegate cell:self didSelectPerson:self.person atIndexPath:self.indexPath];
		
	}
	
}

@end
