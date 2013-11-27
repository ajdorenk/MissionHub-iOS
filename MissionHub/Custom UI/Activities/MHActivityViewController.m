//
//  MHActivityViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 9/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//
// Derived from https://github.com/romaonthego/REActivityViewController
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "MHActivityViewController.h"
#import "MHActivityView.h"

@interface MHActivityViewController ()

@property (nonatomic, strong) NSMutableArray *visibleActivities;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong, readonly) NSArray *activities;
@property (nonatomic, strong) MHActivityView *activityView;

- (CGRect)frameForCurrentOrientation;
- (NSMutableArray *)arrayOfVisibleActivitiesFromActivities:(NSArray *)activities usingActivityItems:(NSArray *)activityItems;
- (CGFloat)height;

@end

@implementation MHActivityViewController

@synthesize backgroundView			= _backgroundView;
@synthesize activities				= _activities;
@synthesize visibleActivities		= _visibleActivities;
@synthesize activityItems			= _activityItems;
@synthesize activityView			= _activityView;
@synthesize presentingController	= _presentingController;

+ (NSArray *)allActivities {
	
	MHLabelActivity *labelActivity				= [[MHLabelActivity alloc] init];
	MHAssignActivity *assignActivity			= [[MHAssignActivity alloc] init];
	MHPermissionsActivity *permissionsActivity	= [[MHPermissionsActivity alloc] init];
	MHStatusActivity *statusActivity			= [[MHStatusActivity alloc] init];
	MHDeleteActivity *deleteActivity			= [[MHDeleteActivity alloc] init];
	MHArchiveActivity *archiveActivity			= [[MHArchiveActivity alloc] init];
	MHEmailActivity *emailActivity				= [[MHEmailActivity alloc] init];
	MHTextActivity *textActivity				= [[MHTextActivity alloc] init];
	MHCallActivity *callActivity				= [[MHCallActivity alloc] init];
	
	return @[ deleteActivity, archiveActivity, permissionsActivity, statusActivity, assignActivity, labelActivity, emailActivity, textActivity, callActivity ];
	
}

- (id)initWithViewController:(UIViewController *)viewController activityItems:(NSArray *)activityItems activities:(NSArray *)activities {
	
    self = [super init];
	
    if (self) {
		
		self.animateFromView					= nil;
		self.animationPosition					= MHActivityViewControllerAnimationPositionBottom;
		self.animationDirection					= MHActivityViewControllerAnimationDirectionUp;
		
		[self willChangeValueForKey:@"activities"];
        _activities = activities;
		[self didChangeValueForKey:@"activities"];
		
		self.visibleActivities					= [self arrayOfVisibleActivitiesFromActivities:activities usingActivityItems:activityItems];
		
        self.presentingController				= viewController;
		self.view.frame							= self.frameForCurrentOrientation;
        
		self.backgroundView						= [[UIView alloc] initWithFrame:self.view.bounds];
		self.backgroundView.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.backgroundView.backgroundColor		= [UIColor blackColor];
		self.backgroundView.alpha				= 0.75;
		[self.view addSubview:self.backgroundView];
		
        self.activityItems						= activityItems;
        
    }
	
    return self;
	
}

- (NSArray *)activityItems {
	
	return self.activityView.activityItems;
	
}

- (NSMutableArray *)arrayOfVisibleActivitiesFromActivities:(NSArray *)activities usingActivityItems:(NSArray *)activityItems {
	
	NSMutableArray *arrayOfVisibleActivities	= [NSMutableArray array];
	
	[activities enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		if ([object isKindOfClass:[MHActivity class]]) {
			
			MHActivity *activity	= object;
			
			if ([activity canPerformWithActivityItems:activityItems]) {
				
				[arrayOfVisibleActivities addObject:activity];
				
			}
			
		}
		
	}];
	
	return arrayOfVisibleActivities;
	
}

- (void)setActivityItems:(NSArray *)activityItems {
	
	MHActivityView *oldActivityView			= self.activityView;
	self.visibleActivities					= [self arrayOfVisibleActivitiesFromActivities:self.activities usingActivityItems:activityItems];
	self.view.frame							= self.frameForCurrentOrientation;
	self.activityView						= [[MHActivityView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) activityItems:activityItems activities:self.activities];
	self.activityView.autoresizingMask		= UIViewAutoresizingFlexibleWidth;
	self.activityView.activityViewController= self;
	[oldActivityView removeFromSuperview];
	[self.view addSubview:self.activityView];
	
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
	
	__typeof (&*self) __weak weakSelf = self;
	[UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
		
		CGRect currentFrame			= weakSelf.frameForCurrentOrientation;
		CGRect afterFrame			= currentFrame;
		
		CGFloat yPosition			= 0;
		
		if (self.animateFromView) {
			
			yPosition = ( self.animationPosition == MHActivityViewControllerAnimationPositionTop ? CGRectGetMinY(self.animateFromView.frame) : CGRectGetMaxY(self.animateFromView.frame) );
			
		} else {
			
			yPosition = ( self.animationPosition == MHActivityViewControllerAnimationPositionTop ? 0 : CGRectGetHeight(self.presentingController.view.frame) );
			
		}
		
		if (self.animationDirection == MHActivityViewControllerAnimationDirectionUp) {
			
			afterFrame.origin.y		= yPosition;
			
		} else {
			
			afterFrame.origin.y		= yPosition - CGRectGetHeight(currentFrame);
			
		}
		
		weakSelf.view.frame			= afterFrame;
		
	} completion:^(BOOL finished) {
		
		[weakSelf.view removeFromSuperview];
		[weakSelf removeFromParentViewController];
		
		if (completion) {
			completion();
		}
		
	}];
}

- (void)presentFromRootViewController {
    
	UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [self presentFromViewController:rootViewController];
	
}

- (void)presentFromViewController:(UIViewController *)controller {
    
	self.presentingController = controller;
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
    [self didMoveToParentViewController:controller];
	
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
	
    [super didMoveToParentViewController:parent];
	
	CGRect currentFrame			= self.frameForCurrentOrientation;
	__block CGRect beforeFrame	= currentFrame;
	__block CGRect afterFrame	= currentFrame;
	
	CGFloat yPosition			= 0;
	
	if (self.animateFromView) {
		
		yPosition = ( self.animationPosition == MHActivityViewControllerAnimationPositionTop ? CGRectGetMinY(self.animateFromView.frame) : CGRectGetMaxY(self.animateFromView.frame) );
		
	} else {
	
		yPosition = ( self.animationPosition == MHActivityViewControllerAnimationPositionTop ? 0 : CGRectGetHeight(self.presentingController.view.frame) );
		
	}
	
	if (self.animationDirection == MHActivityViewControllerAnimationDirectionUp) {
		
		beforeFrame.origin.y	= yPosition;
		afterFrame.origin.y		= yPosition - CGRectGetHeight(currentFrame);
		
	} else {
		
		beforeFrame.origin.y	= yPosition - CGRectGetHeight(currentFrame);
		afterFrame.origin.y		= yPosition;
		
	}
	
	self.view.frame				= beforeFrame;
    
    __typeof (&*self) __weak weakSelf = self;
	[UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
		
		weakSelf.view.frame		= afterFrame;
		
	}];
	
}

- (CGRect)frameForCurrentOrientation {
	
	CGRect presentingControllerFrame = self.presentingController.view.frame;
	
	//TODO: find a better way to check if the presenting Controller has switched the height and width yet
	if (UIDeviceOrientationIsLandscape(self.interfaceOrientation) && CGRectGetWidth(presentingControllerFrame) < CGRectGetHeight(presentingControllerFrame)) {
		
		presentingControllerFrame.size.height	= CGRectGetWidth(self.presentingController.view.frame);
		presentingControllerFrame.size.width	= CGRectGetHeight(self.presentingController.view.frame);
		
	}
	
	return CGRectMake(
					  0,
					  CGRectGetHeight(presentingControllerFrame) - [self heightForParentFrame:presentingControllerFrame],
					  CGRectGetWidth(presentingControllerFrame),
					  [self heightForParentFrame:presentingControllerFrame]);
	
}

- (CGFloat)height {
	
	CGRect presentingControllerFrame = self.presentingController.view.frame;
	
	//TODO: find a better way to check if the presenting Controller has switched the height and width yet
	if (UIDeviceOrientationIsLandscape(self.interfaceOrientation) && CGRectGetWidth(presentingControllerFrame) < CGRectGetHeight(presentingControllerFrame)) {
		
		presentingControllerFrame.size.height	= CGRectGetWidth(self.presentingController.view.frame);
		presentingControllerFrame.size.width	= CGRectGetHeight(self.presentingController.view.frame);
		
	}
	
	return [self heightForParentFrame:presentingControllerFrame];
	
}

- (CGFloat)heightForParentFrame:(CGRect)parentFrame {
	
	CGFloat numberOfActivities			= ( self.visibleActivities ? self.visibleActivities.count : 1 );
	CGFloat maxNumberOfColumnsPerPage	= floor( ( CGRectGetWidth(parentFrame) - MHActivityViewHorizontalMargin ) / ( MHActivityWidth + MHActivityViewHorizontalMargin ) );
	CGFloat numberOfRowsOnCurrentPage	= fmin(MHActivityViewMaxRowPerPage, ceil(numberOfActivities / maxNumberOfColumnsPerPage));
	return (CGFloat)ceil(MHActivityViewVerticalMargin + ( (MHActivityViewVerticalMargin + MHActivityHeight) * numberOfRowsOnCurrentPage ) );
	
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
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
	
	CGRect presentingControllerFrame = self.presentingController.view.frame;
	
	//if the orientation will be landscape and the presentingController's frame has not been switched.
	//TODO: find a better way to check if the presenting Controller has switched the height and width yet
	if (UIDeviceOrientationIsLandscape(toInterfaceOrientation) && CGRectGetWidth(presentingControllerFrame) < CGRectGetHeight(presentingControllerFrame)) {
		
		presentingControllerFrame.size.height	= CGRectGetWidth(self.presentingController.view.frame);
		presentingControllerFrame.size.width	= CGRectGetHeight(self.presentingController.view.frame);
		
	}
	
	UIView *viewToAnimateFrom	= (self.animateFromView ? self.animateFromView : self.presentingController.view);
	CGRect afterFrame			= self.view.frame;
	CGFloat yPosition			= ( self.animationPosition == MHActivityViewControllerAnimationPositionTop ? CGRectGetMinY(viewToAnimateFrom.frame) : CGRectGetMaxY(viewToAnimateFrom.frame) );
	
	if (self.animationDirection == MHActivityViewControllerAnimationDirectionUp) {
		
		afterFrame.origin.y		= yPosition - [self heightForParentFrame:presentingControllerFrame];
		
	} else {
		
		afterFrame.origin.y		= yPosition;
		
	}
	
	afterFrame.size.width		= CGRectGetWidth(presentingControllerFrame);
	afterFrame.size.height		= [self heightForParentFrame:presentingControllerFrame];
	self.view.frame				= afterFrame;
	self.backgroundView.frame	= self.view.bounds;
	self.activityView.frame		= self.view.bounds;
	
}

@end
