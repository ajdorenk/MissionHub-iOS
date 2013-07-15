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

#define GAP_BETWEEN_NAME_AND_LABEL_LIST 20.0f
#define GAP_BETWEEN_LABEL_LIST_AND_LABEL_TITLE 10.0f

@interface MHProfileHeaderViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *headerScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *headerPageControl;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *labelsTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *labelsListLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

//@property (strong, nonatomic) IBOutlet UIImageView *gradientImageView;
@property (nonatomic, assign) BOOL usedPageControl;

- (IBAction)pageChanged:(UIPageControl *)sender;
- (void)darkenTheBackground:(CGFloat)xOffSet;

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
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.imageView.image = [UIImage imageNamed:@"MHProfileHeader_Placeholder.png"];
	self.headerScrollView.contentSize = self.contentView.frame.size;
    self.headerScrollView.scrollsToTop = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setProfileImageWithUrl:(NSString *)urlString {
	
	if (urlString == nil) {
		
        self.imageView.image = [UIImage imageNamed:@"MHProfileHeader_Placeholder.png"];
        
    } else {
		
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
	
	__block NSString *labelsString = @"";
	
	[organizationalLabels enumerateObjectsUsingBlock:^(id setObject, BOOL *stop) {
		
		if ([setObject isKindOfClass:[MHOrganizationalLabel class]]) {
			
			MHOrganizationalLabel *organizationalLabel = (MHOrganizationalLabel *)setObject;
			MHLabel *labelFromOrganizationalLabel = [[MHAPI sharedInstance].currentUser.currentOrganization.labels findWithRemoteID:organizationalLabel.label_id];
			
			if (labelFromOrganizationalLabel != nil) {
				labelsString = [labelsString stringByAppendingFormat:@"%@  •  ", labelFromOrganizationalLabel.name];
			}
			
		}
		
	}];
	
	if ([labelsString length] > 0) {
		
		labelsString = [labelsString substringToIndex:[labelsString rangeOfString:@"  •  " options:NSBackwardsSearch].location];
		
	} else {
		
		labelsString = @"None";
		
	}
	
	self.labelsListLabel.text = labelsString;
	
	[self resetLabelListSize];
	
	
	
}

-(void)resetLabelListSize {
	
	//calculate the size of the label list label with the current string
	CGSize maximumLabelSize = CGSizeMake(self.labelsListLabel.frame.size.width, FLT_MAX);
	CGSize expectedLabelSize = [self.labelsListLabel.text sizeWithFont:self.labelsListLabel.font constrainedToSize:maximumLabelSize lineBreakMode:self.labelsListLabel.lineBreakMode];
	
	//adjust the label list label to the new height and position.
	CGRect newFrame			= self.labelsListLabel.frame;
	newFrame.origin.y		= self.nameLabel.frame.origin.y - GAP_BETWEEN_NAME_AND_LABEL_LIST - expectedLabelSize.height;
	newFrame.size.height	= expectedLabelSize.height;
	self.labelsListLabel.frame = newFrame;
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
    if (scrollView == self.headerScrollView) {
        [self darkenTheBackground:scrollView.contentOffset.x];
    }
	
}

- (void)darkenTheBackground:(CGFloat)xOffSet {
	
    if (xOffSet != 0) {
		
        CGFloat pageWidth = self.headerScrollView.frame.size.width;
        CGFloat alphaForContentView = xOffSet / pageWidth;
		
        if (alphaForContentView > 1.f) {
            alphaForContentView = 1.f;
        } else if (alphaForContentView < 0) {
            alphaForContentView = 0;
        }
        
		self.headerScrollView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7*alphaForContentView];
        
		if (!self.usedPageControl) {
            int page = floor((xOffSet - pageWidth / 2) / pageWidth) + 1;
            self.headerPageControl.currentPage = page;
        }
		
    }
	
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	
    if (scrollView == self.headerScrollView) {
        self.usedPageControl = NO;
    }
	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	
    if (scrollView == self.headerScrollView) {
        self.usedPageControl = NO;
    }
	
}

- (IBAction)pageChanged:(UIPageControl *)sender {
	
    CGFloat headerViewWidth = self.headerScrollView.frame.size.width;
    CGRect frame = self.headerScrollView.frame;
    frame.origin = CGPointMake(headerViewWidth * sender.currentPage, 0);
	
    self.usedPageControl = YES;
    [self.headerScrollView scrollRectToVisible:frame animated:YES];
	
}

@end
