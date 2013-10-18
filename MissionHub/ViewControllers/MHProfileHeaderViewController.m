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
#import "MHPerson+Helper.h"

#define GAP_BETWEEN_NAME_AND_LABEL_LIST 20.0f
#define GAP_BETWEEN_LABEL_LIST_AND_LABEL_TITLE 10.0f
CGFloat const MHProfileHeaderLabelListMarginVertical = 10.0f;
CGFloat const MHProfileHeaderLabelListMarginHorizontal = 10.0f;
CGFloat const MHProfileHeaderLabelTitleMarginVertical = 25.0f;
CGFloat const MHProfileHeaderNameMarginVertical = 25.0f;
CGFloat const MHProfileHeaderContentBuffer = 40.0f;


@interface MHProfileHeaderViewController ()

@property (nonatomic, weak) IBOutlet DWTagList *labelList;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UILabel *labelsTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

- (void)updateLayoutWithFrame:(CGRect)frame;

@end


@implementation MHProfileHeaderViewController

@synthesize person = _person;

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
	
	[self updateLayoutWithFrame:self.view.frame];
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.imageView.image			= [UIImage imageNamed:@"MH_Mobile_Profile_Header_Placeholder.png"];
	self.view.autoresizingMask		= UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.labelList.clipsToBounds	= NO;
    
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	[self updateLayoutWithFrame:self.view.frame];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPerson:(MHPerson *)person {
	
	[self willChangeValueForKey:@"person"];
	_person = person;
	[self didChangeValueForKey:@"person"];
	
	[self setProfileImageWithUrl:person.picture];
	[self setName:[person fullName]];
	[self setLabelListWithSetOfOrganizationalLabels:person.labels];
	
}

- (void)setProfileImageWithUrl:(NSString *)urlString {
	
	if (urlString == nil) {
		
        self.imageView.image = [UIImage imageNamed:@"MH_Mobile_Profile_Header_Placeholder.png"];
        
    } else {
		
		urlString = [urlString stringByAppendingString:@"?type=large"];
        [self.imageView setImageWithURL:[NSURL URLWithString:urlString]
					   placeholderImage:[UIImage imageNamed:@"MH_Mobile_Profile_Header_Placeholder.png"]];
    }
	
}

- (void)setName:(NSString *)nameString {
	
	if (nameString != nil) {
		self.nameLabel.text = nameString;
	}

}

- (void)setLabelListWithSetOfOrganizationalLabels:(NSSet *)organizationalLabels {
	
	__block NSMutableArray *labelArray = [NSMutableArray array];
	
	[organizationalLabels enumerateObjectsUsingBlock:^(id setObject, BOOL *stop) {
		
		if ([setObject isKindOfClass:[MHOrganizationalLabel class]]) {
			
			MHOrganizationalLabel *organizationalLabel = (MHOrganizationalLabel *)setObject;
			MHLabel *labelFromOrganizationalLabel = [[MHAPI sharedInstance].currentUser.currentOrganization.labels findWithRemoteID:organizationalLabel.label_id];
			
			if (labelFromOrganizationalLabel != nil) {
				[labelArray addObject:labelFromOrganizationalLabel.name];
			}
			
		}
		
	}];
	
	if ([labelArray count] == 0) {
		
		[labelArray addObject:@"No Labels for Person"];
		
	}
	
	[self.labelList setTags:labelArray];
	
}

- (void)updateLayout {
	
	[self updateLayoutWithFrame:self.view.frame];
	
}

- (void)updateLayoutWithFrame:(CGRect)frame {
	
	if (CGRectGetWidth(self.imageView.frame) != CGRectGetWidth(self.view.frame)) {
		self.imageView.frame		= self.view.bounds;
	}
	
	self.contentView.frame			= CGRectInset(self.view.bounds, 0, -MHProfileHeaderContentBuffer);
	
	self.labelList.frame			= CGRectMake(MHProfileHeaderLabelListMarginHorizontal,
												 MHProfileHeaderContentBuffer + CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.labelList.frame) - MHProfileHeaderLabelListMarginVertical,
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
	
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	CGRect frame	= self.view.frame;
	frame.size		= CGSizeMake(CGRectGetWidth(self.view.frame), 150);
	[self updateLayoutWithFrame:frame];
	
}

@end
