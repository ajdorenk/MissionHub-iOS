//
//  MHParallaxTopViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/27/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHProfileHeaderViewController.h"
#import "MHProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DWTagList.h"

#define GAP_BETWEEN_NAME_AND_LABEL_LIST 20.0f
#define GAP_BETWEEN_LABEL_LIST_AND_LABEL_TITLE 10.0f
CGFloat const MHProfileHeaderLabelListMarginVertical = 10.0f;
CGFloat const MHProfileHeaderLabelListMarginHorizontal = 10.0f;
CGFloat const MHProfileHeaderLabelTitleMarginVertical = 25.0f;
CGFloat const MHProfileHeaderNameMarginVertical = 25.0f;
CGFloat const MHProfileHeaderContentBuffer = 40.0f;


@interface MHProfileHeaderViewController ()

@property (strong, nonatomic) IBOutlet DWTagList *labelList;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *labelsTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

- (void)updateLayout;

@end


@implementation MHProfileHeaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)awakeFromNib {
	
	[super awakeFromNib];
	
	[self updateLayout];
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.imageView.image			= [UIImage imageNamed:@"MHProfileHeader_Placeholder.png"];
	self.view.autoresizingMask		= UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.labelList.clipsToBounds	= NO;
    
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	[self updateLayout];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setPerson:(MHPerson *)person {
	
	[self setProfileImageWithUrl:person.picture];
	[self setName:[person fullName]];
	[self setLabelListWithSetOfOrganizationalLabels:person.labels];
	
}

-(void)setProfileImageWithUrl:(NSString *)urlString {
	
	if (urlString == nil) {
		
        self.imageView.image = [UIImage imageNamed:@"MHProfileHeader_Placeholder.png"];
        
    } else {
		
		urlString = [urlString stringByAppendingString:@"?type=large"];
        [self.imageView setImageWithURL:[NSURL URLWithString:urlString]
					   placeholderImage:[UIImage imageNamed:@"MHProfileHeader_Placeholder.png"]];
    }
	
}

-(void)setName:(NSString *)nameString {
	
	if (nameString != nil) {
		self.nameLabel.text = nameString;
	}

}

-(void)setLabelListWithSetOfOrganizationalLabels:(NSSet *)organizationalLabels {
	
	//__block NSString *labelsString = @"";
	__block NSMutableArray *labelArray = [NSMutableArray array];
	
	[organizationalLabels enumerateObjectsUsingBlock:^(id setObject, BOOL *stop) {
		
		if ([setObject isKindOfClass:[MHOrganizationalLabel class]]) {
			
			MHOrganizationalLabel *organizationalLabel = (MHOrganizationalLabel *)setObject;
			MHLabel *labelFromOrganizationalLabel = [[MHAPI sharedInstance].currentUser.currentOrganization.labels findWithRemoteID:organizationalLabel.label_id];
			
			if (labelFromOrganizationalLabel != nil) {
				//labelsString = [labelsString stringByAppendingFormat:@"%@  •  ", labelFromOrganizationalLabel.name];
				[labelArray addObject:labelFromOrganizationalLabel.name];
			}
			
		}
		
	}];
	/*
	if ([labelsString length] > 0) {
		
		labelsString = [labelsString substringToIndex:[labelsString rangeOfString:@"  •  " options:NSBackwardsSearch].location];
		
	} else {
		
		labelsString = @"None";
		
	}
	*/
	
	 
	//self.labelsListLabel.text = labelsString;
	
	//[self resetLabelListSize];
	
	if ([labelArray count] == 0) {
		
		[labelArray addObject:@"No Labels for Person"];
		
	}
	/*
	if (self.labelList != nil) {
		
		[self.labelList removeFromSuperview];
		
	}
	
	self.labelList = [[DWTagList alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.labelsTitleLabel.frame) + 5, CGRectGetWidth(self.view.frame) - 20, CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.labelsTitleLabel.frame) - 10)];
	*/
	[self.labelList setTags:labelArray];
	
	//[self.view addSubview:self.labelList];
	
}

- (void)updateLayout {
	
	if (CGRectGetWidth(self.imageView.frame) != CGRectGetWidth(self.view.frame)) {
		self.imageView.frame		= self.view.frame;
	}
	
	self.contentView.frame			= CGRectInset(self.view.frame, 0, -MHProfileHeaderContentBuffer);
	
	self.labelList.frame			= CGRectMake(MHProfileHeaderLabelListMarginHorizontal,
												 MHProfileHeaderContentBuffer + CGRectGetMaxY(self.view.frame) - CGRectGetHeight(self.labelList.frame) - MHProfileHeaderLabelListMarginVertical,
												 CGRectGetWidth(self.view.frame) - 2 * MHProfileHeaderLabelListMarginHorizontal,
												 CGRectGetHeight(self.labelList.frame));
	
	self.labelsTitleLabel.center	= self.contentView.center;
	self.labelsTitleLabel.frame		= CGRectMake(CGRectGetMinX(self.labelsTitleLabel.frame),
												 CGRectGetMinY(self.labelList.frame) - MHProfileHeaderLabelTitleMarginVertical,
												 CGRectGetWidth(self.labelsTitleLabel.frame),
												 CGRectGetHeight(self.labelsTitleLabel.frame));
	
	self.nameLabel.center			= self.contentView.center;
	self.nameLabel.frame			= CGRectMake(CGRectGetMinX(self.nameLabel.frame),
												 CGRectGetMinY(self.labelsTitleLabel.frame) - MHProfileHeaderNameMarginVertical,
												 CGRectGetWidth(self.nameLabel.frame),
												 CGRectGetHeight(self.nameLabel.frame));
	
	
}

#pragma mark -
#pragma mark Orientation

- (NSUInteger)supportedInterfaceOrientations {
	
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
	
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
	
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	[self updateLayout];
	
}

@end
