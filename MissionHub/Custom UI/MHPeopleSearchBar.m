//
//  MHPeopleSearchBar.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/18/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHPeopleSearchBar.h"
#import "MHToolbar.h"

@interface MHPeopleSearchBar ()

@property (nonatomic, strong) UITextField *searchTextField;

@end

@implementation MHPeopleSearchBar

@synthesize searchTextField	= _searchTextField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)layoutSubviews {
	
    [super layoutSubviews];
	
	if (self.searchTextField) {
		
		CGRect frame					= self.searchTextField.frame;
		frame.origin.x					= 0;
		frame.origin.y					= 0;
		frame.size.height				= self.frame.size.height;
		frame.size.width				= self.frame.size.width;
		self.searchTextField.frame		= frame;
		self.searchTextField.font		= [UIFont fontWithName:@"Helvetica" size:20];
		
		UIImage *image					= [UIImage imageNamed:@"MH_Mobile_Searchbar_Image.png"];
        UIImageView *view				= [[UIImageView alloc] initWithImage:image];
        self.searchTextField.leftView	= view;
		
	}
    
//	self.layer.shadowOpacity			= 0.3f;
//	self.layer.shadowRadius				= 2.0f;
//	self.layer.shadowColor				= [UIColor blackColor].CGColor;
	self.placeholder					= @"Search";
	self.backgroundImage				= [UIImage imageNamed:@"MH_Mobile_Searchbar_Background.png"];
	
}

- (void)awakeFromNib {
	
    [super awakeFromNib];
    
    for (int i = (int)self.subviews.count - 1; i >= 0; i--) {
		
        UIView *subview = [self.subviews objectAtIndex:i];
        if ([subview.class isSubclassOfClass:[UITextField class]]) {
			
            self.searchTextField = (UITextField *)subview;
			
        }
		
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
