//
//  MHProfileInfoViewController.h
//  MissionHub
//
//  Created by Michael Harrison on 7/12/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHProfileProtocol.h"

@interface MHProfileInfoViewController : UITableViewController <MHProfileProtocol> {
	
	NSString *_gender;
	NSString *_followupStatus;
	NSMutableArray *_emailAddresses;
	NSMutableArray *_phoneNumbers;
	NSMutableArray *_addresses;
	
	NSMutableArray *_sectionTitles;
	NSMutableArray *_sections;
	
}

@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *followupStatus;
@property (nonatomic, strong) NSMutableArray *emailAddresses;
@property (nonatomic, strong) NSMutableArray *phoneNumbers;
@property (nonatomic, strong) NSMutableArray *addresses;

@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, strong) NSMutableArray *sections;

//@property (nonatomic,strong) UIImage *infoDemoImage;

@end
