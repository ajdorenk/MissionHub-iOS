//
//  MHPerson.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/13/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHPersonCell.h"
#import "MHCheckbox.h"
#import "UIImageView+AFNetworking.h"

CGFloat static MHPersonCelliPadGap = 20.0;

@interface MHPersonCell () <MHCheckboxDelegate>

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *field;
@property (nonatomic, weak) IBOutlet UIImageView *profilePicture;
@property (nonatomic, weak) IBOutlet MHCheckbox *checkbox;
@property (nonatomic, weak) IBOutlet UIView *nameBackgroundView;

@end

@implementation MHPersonCell

@synthesize cellDelegate		= _cellDelegate;
@synthesize person				= _person;
@synthesize indexPath			= _indexPath;
@synthesize field				= _field;
@synthesize name				= _name;
@synthesize profilePicture		= _profilePicture;
@synthesize checkbox			= _checkbox;
@synthesize nameBackgroundView	= _nameBackgroundView;


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
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		
        self.nameBackgroundView.layer.backgroundColor = [UIColor whiteColor].CGColor;
		
    } //else {
		
		self.nameBackgroundView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
		self.nameBackgroundView.layer.borderWidth = 1.0;
		
	//}
	
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
		
        self.profilePicture.image = [UIImage imageNamed:@"MH_Mobile_PersonCell_Placeholder.png"];
        
    } else {
		
        [self.profilePicture setImageWithURL:[NSURL URLWithString:person.picture]
					   placeholderImage:[UIImage imageNamed:@"MH_Mobile_PersonCell_Placeholder.png"]];
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
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
	
		self.nameBackgroundView.frame	= CGRectMake(CGRectGetMinX(self.nameBackgroundView.frame),
													 CGRectGetMinY(self.nameBackgroundView.frame),
													 CGRectGetWidth(self.frame) * 0.5,
													 CGRectGetHeight(self.nameBackgroundView.frame) + 1);
		
		self.field.frame	= CGRectMake(CGRectGetMaxX(self.nameBackgroundView.frame) + MHPersonCelliPadGap,
										 CGRectGetMinY(self.field.frame),
										 CGRectGetWidth(self.frame) * 0.5 - MHPersonCelliPadGap,
										 CGRectGetHeight(self.field.frame));
		
	} else {
	
		self.nameBackgroundView.frame	= CGRectMake(CGRectGetMinX(self.nameBackgroundView.frame),
													 CGRectGetMinY(self.nameBackgroundView.frame),
													 CGRectGetWidth(self.frame) - CGRectGetMinX(self.nameBackgroundView.frame) + 1,
													 CGRectGetHeight(self.nameBackgroundView.frame));
		
		self.field.frame	= CGRectMake(CGRectGetMinX(self.field.frame),
													 CGRectGetMinY(self.field.frame),
													 CGRectGetWidth(self.frame) - CGRectGetMinX(self.field.frame),
													 CGRectGetHeight(self.field.frame));
		
	}
	
}

@end
