//
//  MHSortHeader.m
//  MissionHub
//
//  Created by Michael Harrison on 9/11/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHSortHeader.h"

CGFloat const MHSortHeaderMargin			= 5.0f;
CGFloat const MHSortHeaderSpacing			= 10.0f;
CGFloat const MHSortHeaderHeight			= 32.0f;
//CGFloat const MHSortHeaderAllButtonWidth	= 20.0f;
CGFloat const MHSortHeaderFieldButtonWidth	= 150.0f;
CGFloat const MHSortHeaderSortButtonWidth	= 60.0f;

@interface MHSortHeader ()

@property (nonatomic, weak) id<MHSortHeaderDelegate>delegate;
@property (nonatomic, weak) UITableView *tableView;
//@property (nonatomic, strong) UIButton *allButton;
@property (nonatomic, strong) UIButton *fieldButton;
@property (nonatomic, strong) UIButton *sortButton;

- (void)sortOnOff:(UIButton *)button;
- (void)chooseSortField:(id)sender;
//- (void)allButtonPressed:(id)sender;

@end

@implementation MHSortHeader

@synthesize tableView		= _tableView;
//@synthesize allButton		= _allButton;
@synthesize fieldButton		= _fieldButton;
@synthesize sortButton		= _sortButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		
    }
    return self;
}

+ (instancetype)headerWithTableView:(UITableView *)tableView sortField:(MHPersonSortFields)sortField delegate:(id<MHSortHeaderDelegate>)delegate {
	
	CGRect frame				= CGRectMake(0, 0, CGRectGetWidth(tableView.frame), MHSortHeaderHeight);
	
	MHSortHeader *header	= (MHSortHeader *)[[self alloc] initWithFrame:frame];
	
    if (header) {
        // Initialization code
		
		header.delegate			= delegate;
		header.tableView			= tableView;
		header.backgroundColor	= [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1];
		
//		header.allButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//		header.allButton.frame	= CGRectMake(MHSortHeaderMargin, MHSortHeaderMargin, MHSortHeaderAllButtonWidth, MHSortHeaderHeight - 2 * MHSortHeaderMargin);
//		header.allButton.titleLabel.textColor = [UIColor whiteColor];
//		header.allButton.backgroundColor = [UIColor clearColor];
//		header.allButton.titleLabel.textAlignment = NSTextAlignmentLeft;
//		header.allButton.titleLabel.text = @"All";
//		[header.sortButton addTarget:header action:@selector(allButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//		[header addSubview:header.allButton];
		
		header.sortButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[header.sortButton setFrame:CGRectMake(CGRectGetWidth(header.frame) - MHSortHeaderSortButtonWidth - MHSortHeaderMargin,
													  MHSortHeaderMargin,
													  MHSortHeaderSortButtonWidth,
													  MHSortHeaderHeight - 2 * MHSortHeaderMargin)];
		[header.sortButton setTintColor:[UIColor clearColor]];
		[header.sortButton setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_SortButton_40.png"] forState:UIControlStateNormal];
		[header.sortButton setTitleColor:[UIColor colorWithRed:128.0/255.0 green:130.0/255.0 blue:132.0/255.0 alpha:1] forState:UIControlStateNormal];
		[header.sortButton setTitle:@"Sort: off" forState:UIControlStateNormal];
		[header.sortButton setTitleColor:[UIColor colorWithRed:128.0/255.0 green:130.0/255.0 blue:132.0/255.0 alpha:1] forState:UIControlStateNormal];
		[header.sortButton.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
		[header.sortButton setBackgroundColor:[UIColor clearColor]];
		[header.sortButton addTarget:header action:@selector(sortOnOff:) forControlEvents:UIControlEventTouchUpInside];
		[header addSubview:header.sortButton];
		
		//Add sortFieldButton
		header.fieldButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[header.fieldButton setFrame:CGRectMake(CGRectGetMinX(header.sortButton.frame) - MHSortHeaderFieldButtonWidth - MHSortHeaderSpacing,
											 MHSortHeaderMargin,
											 MHSortHeaderFieldButtonWidth,
											 MHSortHeaderHeight - 2 * MHSortHeaderMargin)];
		[header.fieldButton setTintColor:[UIColor clearColor]];
		[header.fieldButton setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_ColumnButton_40.png"] forState:UIControlStateNormal];
		[header.fieldButton setBackgroundColor:[UIColor clearColor]];
		[header.fieldButton.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
		[header.fieldButton setTitle:[MHPerson fieldNameForSortField:sortField] forState:UIControlStateNormal];
		[header.fieldButton setTitleColor:[UIColor colorWithRed:128.0/255.0 green:130.0/255.0 blue:132.0/255.0 alpha:1] forState:UIControlStateNormal];
		[header.fieldButton addTarget:header action:@selector(chooseSortField:) forControlEvents:UIControlEventTouchUpInside];
		
		[header addSubview:header.fieldButton];
		
    }
	
    return header;
	
}

//- (void)allButtonPressed:(id)sender {
//    
//	if ([self.delegate respondsToSelector:@selector(allButtonPressed)]) {
//		
//		[self.delegate allButtonPressed];
//		
//	}
//	
//}

- (void)chooseSortField:(id)sender {
    
	if ([self.delegate respondsToSelector:@selector(fieldButtonPressed)]) {
		
		[self.delegate fieldButtonPressed];
		
	}
	
}

- (void)sortOnOff:(UIButton *)button {
	
	MHRequestOptionsOrderDirections direction	= MHRequestOptionsOrderDirectionNone;
    
    if ([button.titleLabel.text isEqualToString:@"Sort: off"]) {
		
        [button setTitle:@"Sort: asc" forState:UIControlStateNormal];
		direction	= MHRequestOptionsOrderDirectionAsc;
		
    } else if ([button.titleLabel.text isEqualToString:@"Sort: asc"]) {
		
        [button setTitle:@"Sort: desc" forState:UIControlStateNormal];
		direction	= MHRequestOptionsOrderDirectionDesc;
		
    } else if ([button.titleLabel.text isEqualToString:@"Sort: desc"]) {
		
        [button setTitle:@"Sort: off" forState:UIControlStateNormal];
		
    }
	
	if ([self.delegate respondsToSelector:@selector(sortDirectionDidChangeTo:)]) {
		
		[self.delegate sortDirectionDidChangeTo:direction];
		
	}
	
}

- (void)updateInterfaceWithSortField:(MHPersonSortFields)sortField {
	
	[self.fieldButton setTitle:[MHPerson fieldNameForSortField:sortField] forState:UIControlStateNormal];
	
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	[self.sortButton setFrame:CGRectMake(CGRectGetWidth(self.frame) - MHSortHeaderSortButtonWidth - MHSortHeaderMargin,
												  MHSortHeaderMargin,
												  MHSortHeaderSortButtonWidth,
												  MHSortHeaderHeight - 2 * MHSortHeaderMargin)];
	
	[self.fieldButton setFrame:CGRectMake(CGRectGetMinX(self.sortButton.frame) - MHSortHeaderFieldButtonWidth - MHSortHeaderSpacing,
												   MHSortHeaderMargin,
												   MHSortHeaderFieldButtonWidth,
												   MHSortHeaderHeight - 2 * MHSortHeaderMargin)];
	
	
	//self.allButton.frame	= CGRectMake(MHSortHeaderMargin, MHSortHeaderMargin, MHSortHeaderAllButtonWidth, MHSortHeaderHeight - 2 * MHSortHeaderMargin);
	
}

@end
