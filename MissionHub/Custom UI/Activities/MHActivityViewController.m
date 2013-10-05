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

- (CGRect)frameForCurrentOrientation;
- (CGFloat)height;

@end

@implementation MHActivityViewController

@synthesize backgroundView			= _backgroundView;
@synthesize activities				= _activities;
@synthesize activityItems			= _activityItems;
@synthesize userInfo				= _userInfo;
@synthesize activityView			= _activityView;
@synthesize presentingController	= _presentingController;

+ (NSArray *)allActivities {
	
	MHLabelActivity *labelActivity				= [[MHLabelActivity alloc] init];
	MHAssignActivity *assignActivity			= [[MHAssignActivity alloc] init];
	MHPermissionsActivity *permissionsActivity	= [[MHPermissionsActivity alloc] init];
	MHDeleteActivity *deleteActivity			= [[MHDeleteActivity alloc] init];
	MHArchiveActivity *archiveActivity			= [[MHArchiveActivity alloc] init];
	MHEmailActivity *emailActivity				= [[MHEmailActivity alloc] init];
	MHTextActivity *textActivity				= [[MHTextActivity alloc] init];
	
	return @[ deleteActivity, archiveActivity, permissionsActivity, assignActivity, labelActivity, emailActivity, textActivity ];
	
}

- (id)initWithViewController:(UIViewController *)viewController activityItems:(NSArray *)activityItems activities:(NSArray *)activities {
	
    self = [super init];
	
    if (self) {
		
		[self willChangeValueForKey:@"activities"];
        _activities = activities;
		[self didChangeValueForKey:@"activities"];
		
        self.presentingController				= viewController;
		//self.view.backgroundColor				= [UIColor whiteColor];
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

- (void)setActivityItems:(NSArray *)activityItems {
	
	MHActivityView *oldActivityView			= self.activityView;
	self.activityView						= [[MHActivityView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) activityItems:activityItems activities:self.activities];
	self.activityView.autoresizingMask		= UIViewAutoresizingFlexibleWidth;
	self.activityView.activityViewController= self;
	[oldActivityView removeFromSuperview];
	[self.view addSubview:self.activityView];
	
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
	__typeof (&*self) __weak weakSelf = self;
	[UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
		
		CGRect afterFrame				= weakSelf.frameForCurrentOrientation;
		afterFrame.origin.y				= CGRectGetMaxY(self.presentingController.view.frame);
		//afterFrame.origin.y				= -CGRectGetHeight(self.view.frame);
		
		weakSelf.view.frame				= afterFrame;
		//weakSelf.backgroundView.alpha	= 0.0;
		
	} completion:^(BOOL finished) {
		
		[weakSelf.view removeFromSuperview];
		[weakSelf removeFromParentViewController];
		
		if (completion) {
			completion();
		}
		
	}];
}

- (void)presentFromRootViewController
{
    
	UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [self presentFromViewController:rootViewController];
	
}

- (void)presentFromViewController:(UIViewController *)controller
{
    
	self.presentingController = controller;
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
    [self didMoveToParentViewController:controller];
	
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
	
	CGRect beforeFrame			= self.frameForCurrentOrientation;
	beforeFrame.origin.y		= CGRectGetMaxY(self.presentingController.view.frame);
	//beforeFrame.origin.y		= -CGRectGetHeight(self.view.frame);
	
	self.view.frame				= beforeFrame;
	//self.backgroundView.alpha	= 0.0;
    
    __typeof (&*self) __weak weakSelf = self;
	[UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
		
		//weakSelf.backgroundView.alpha	= 0.4;
		weakSelf.view.frame		= weakSelf.frameForCurrentOrientation;
		//weakSelf.view.frame		= weakSelf.view.bounds;
		
	}];
}

- (CGRect)frameForCurrentOrientation {
	
	return CGRectMake(
					  0,
					  CGRectGetHeight(self.presentingController.view.frame) - self.height,
					  CGRectGetWidth(self.view.frame),
					  self.height);
	
}

- (CGFloat)height
{
    
	CGFloat numberOfActivities			= ( self.activities ? self.activities.count : 0 );
	CGFloat maxNumberOfColumnsPerPage	= floor( ( CGRectGetWidth(self.presentingController.view.frame) - MHActivityViewHorizontalMargin ) / ( MHActivityWidth + MHActivityViewHorizontalMargin ) );
	CGFloat numberOfRowsOnCurrentPage	= fmin(MHActivityViewMaxRowPerPage, ceil(numberOfActivities / maxNumberOfColumnsPerPage));
	return (CGFloat)ceil(MHActivityViewVerticalMargin + ( (MHActivityViewVerticalMargin + MHActivityHeight) * numberOfRowsOnCurrentPage ) );
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -
#pragma mark Helpers

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    block = [block copy];
    [self performSelector:@selector(runBlockAfterDelay:) withObject:block afterDelay:delay];
}

- (void)runBlockAfterDelay:(void (^)(void))block
{
	if (block != nil)
		block();
}

#pragma mark -
#pragma mark Orientation

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	
	CGRect frame = self.view.frame;
	
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
		frame.origin.y		= CGRectGetHeight(self.presentingController.view.frame) - self.height;
		frame.size.width	= CGRectGetWidth(self.presentingController.view.frame);
	} else {
		frame.origin.y		= CGRectGetWidth(self.presentingController.view.frame) - self.height;
		frame.size.width	= CGRectGetHeight(self.presentingController.view.frame);
	}
	
	frame.size.height			= self.height;
	self.view.frame				= frame;
	self.backgroundView.frame	= self.view.bounds;
	self.activityView.frame		= self.view.bounds;
	
}

@end
