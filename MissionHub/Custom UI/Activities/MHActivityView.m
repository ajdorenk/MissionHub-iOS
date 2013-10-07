//
// MHActivityView.h
// MissionHub
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

#import "MHActivityView.h"
#import "MHActivityViewController.h"

CGFloat const MHActivityWidth					= 60.0f;
CGFloat const MHActivityHeight					= 40.0f;
CGFloat const MHActivityViewVerticalMargin		= 5.0f;
CGFloat const MHActivityViewHorizontalMargin	= 2.0f;
NSUInteger const MHActivityViewMaxRowPerPage	= 2;
CGFloat const MHActivityImageWidth				= 24.0f;
CGFloat const MHActivityImageHeight				= 24.0f;
CGFloat const MHActivityLabelWidth				= MHActivityWidth;
CGFloat const MHActivityLabelHeight				= 15.0f;
CGFloat const MHActivityPageControlHeight		= 10.0f;

#ifdef __IPHONE_6_0 // iOS6 and later
#   define UITextAlignmentCenter    NSTextAlignmentCenter
#   define UITextAlignmentLeft      NSTextAlignmentLeft
#   define UITextAlignmentRight     NSTextAlignmentRight
#   define UILineBreakModeTailTruncation     NSLineBreakByTruncatingTail
#   define UILineBreakModeMiddleTruncation   NSLineBreakByTruncatingMiddle
#endif

@interface MHActivityView ()

@property (nonatomic, strong) NSMutableArray *viewsOnDisplay;
@property (nonatomic, strong) void (^updateVisibleActivitiesCompletionBlock)(void);
@property (nonatomic, assign) BOOL updatingVisibleActivities;

- (NSUInteger)numberOfPagesForActivities;
- (NSInteger)maxActivitiesPerPage;
- (void)enumerateActivitiesWithBlock:(void (^)(MHActivity *activity, NSInteger index, NSInteger row, NSInteger column, NSInteger page))activityblock;
- (void)updateVisibleActivities;

@end

@implementation MHActivityView

@synthesize activities			= _activities;
@synthesize activityItems		= _activityItems;
@synthesize viewsOnDisplay		= _viewsOnDisplay;
@synthesize activityViewController	= _activityViewController;
@synthesize scrollView			= _scrollView;
@synthesize pageControl			= _pageControl;
@synthesize maxRowsPerPage		= _maxRowsPerPage;
@synthesize maxColumnsPerPage	= _maxColumnsPerPage;


- (id)initWithFrame:(CGRect)frame activityItems:(NSArray *)activityItems activities:(NSArray *)activities {
    
    self = [super initWithFrame:frame];
	
    if (self) {
		
        self.clipsToBounds		= YES;
        self.activities			= activities;
		self.viewsOnDisplay		= [NSMutableArray array];
		
		self.maxRowsPerPage		= MHActivityViewMaxRowPerPage;
		self.maxColumnsPerPage	= 0;
		
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        self.scrollView.showsHorizontalScrollIndicator	= NO;
        self.scrollView.showsVerticalScrollIndicator	= NO;
        self.scrollView.delegate						= self;
        self.scrollView.autoresizingMask				= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.scrollView];
		
		NSInteger numberOfPages			= self.numberOfPagesForActivities;
        self.scrollView.contentSize		= CGSizeMake((numberOfPages) * CGRectGetWidth(self.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.pagingEnabled	= YES;
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - MHActivityPageControlHeight - MHActivityViewVerticalMargin, CGRectGetWidth(self.frame), MHActivityPageControlHeight)];
        self.pageControl.numberOfPages	= numberOfPages;
        [self.pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.pageControl];
        
        if (self.pageControl.numberOfPages <= 1) {
            self.pageControl.hidden		= YES;
            self.scrollView.scrollEnabled = NO;
        }
		
		self.activityItems	= activityItems;
		
    }
	
    return self;
}

- (void)setActivityItems:(NSArray *)activityItems {
	
	[self willChangeValueForKey:@"activityItems"];
	_activityItems	= [activityItems copy];
	[self didChangeValueForKey:@"activityItems"];
	
	[self updateVisibleActivities];
	
	
}

- (void)updateVisibleActivities {
	
	[self.viewsOnDisplay enumerateObjectsUsingBlock:^(id view, NSUInteger index, BOOL *stop) {
		
		if ([view respondsToSelector:@selector(removeFromSuperview)]) {
			
			[view removeFromSuperview];
			
		}
		
		[self.viewsOnDisplay removeObject:view];
		
	}];
	
	__weak __typeof(&*self)weakSelf = self;
	[self enumerateActivitiesWithBlock:^(MHActivity *activity, NSInteger index, NSInteger row, NSInteger column, NSInteger page) {
		
		if ([activity isKindOfClass:[MHActivity class]]) {
			
			if ([(MHActivity *)activity canPerformWithActivityItems:self.activityItems]) {
				
				UIView *view = [weakSelf viewForActivity:activity
												   index:index
													   x:(MHActivityViewHorizontalMargin + (column * MHActivityWidth) + (column * MHActivityViewHorizontalMargin)) + (page * CGRectGetWidth(weakSelf.frame))
													   y:(MHActivityViewVerticalMargin + (row * MHActivityHeight) + (row * MHActivityViewVerticalMargin))];
				
				[weakSelf.scrollView addSubview:view];
				[self.viewsOnDisplay addObject:view];
				
			}
			
		}
		
	}];
	
	NSInteger numberOfPages			= self.numberOfPagesForActivities;
	self.scrollView.contentSize		= CGSizeMake((numberOfPages) * CGRectGetWidth(self.frame), CGRectGetHeight(self.scrollView.frame));
	
	self.pageControl.numberOfPages	= numberOfPages;
	
	if (self.pageControl.numberOfPages <= 1) {
		self.pageControl.hidden		= YES;
		self.scrollView.scrollEnabled = NO;
	}
	
}

- (NSUInteger)maxColumnsPerPage {
	
	return (NSInteger)floor( ( CGRectGetWidth(self.frame) - MHActivityViewHorizontalMargin ) / ( MHActivityWidth + MHActivityViewHorizontalMargin ) );
	
}

- (NSInteger)maxActivitiesPerPage {
	
	return self.maxRowsPerPage * self.maxColumnsPerPage;
	
}

- (NSUInteger)numberOfPagesForActivities {
	
	if (self.viewsOnDisplay) {
		
		return ceil( (CGFloat)self.viewsOnDisplay.count / ( (CGFloat)self.maxActivitiesPerPage ) );
		
	} else {
		
		return 0;
		
	}
	
}

- (void)enumerateActivitiesWithBlock:(void (^)(MHActivity *activity, NSInteger index, NSInteger row, NSInteger column, NSInteger page))activityblock {
	
	NSInteger index	= 0;
	NSInteger row	= -1;
	NSInteger page	= -1;
	NSArray *activities	= [self.activities copy];
	NSInteger numberOfActivities = self.activities.count;
	
	for (NSInteger activityCount = 0; activityCount < numberOfActivities; activityCount++) {
		id activity = [activities objectAtIndex:activityCount];
		NSInteger col;
		
		col = index % self.maxColumnsPerPage;
		
		if (index % self.maxColumnsPerPage == 0) {
			row++;
		}
		
		if (index % self.maxActivitiesPerPage == 0) {
			row = 0;
			page++;
		}
		
		activityblock(activity, index, row, col, page);
		
		index++;
	}
	
}

- (UIView *)viewForActivity:(MHActivity *)activity index:(NSInteger)index x:(NSInteger)x y:(NSInteger)y {
	
    UIView *view		= [[UIView alloc] initWithFrame:CGRectMake(x, y, MHActivityWidth, MHActivityHeight)];
	view.tag			= index + 1;
    
    UIButton *button	= [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame		= CGRectMake( 0.5 * (MHActivityWidth - MHActivityImageWidth), 0, MHActivityImageWidth, MHActivityImageHeight);
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:activity.activityImage forState:UIControlStateNormal];
    button.accessibilityLabel = activity.activityTitle;
    [view addSubview:button];
    
    UILabel *label		= [[UILabel alloc] initWithFrame:CGRectMake(0, MHActivityHeight - MHActivityLabelHeight, MHActivityLabelWidth, MHActivityLabelHeight)];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor		= [UIColor whiteColor];
    label.shadowColor	= [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    label.shadowOffset	= CGSizeMake(0, -1);
    label.text			= activity.activityTitle;
    label.font			= [UIFont boldSystemFontOfSize:11];
    label.numberOfLines = 1;
    [view addSubview:label];
    
    return view;
	
}

- (void)layoutSubviews {
	
    [super layoutSubviews];
	
	__weak __typeof(&*self)weakSelf = self;
	[self enumerateActivitiesWithBlock:^(MHActivity *activity, NSInteger index, NSInteger row, NSInteger column, NSInteger page) {
		
		UIView *view	= [weakSelf viewWithTag:index + 1];
		CGRect frame	= view.frame;
		frame.origin.x	= (MHActivityViewHorizontalMargin + (column * MHActivityWidth) + (column * MHActivityViewHorizontalMargin)) + (page * CGRectGetWidth(weakSelf.frame));
		frame.origin.y	= (MHActivityViewVerticalMargin + (row * MHActivityHeight) + (row * MHActivityViewVerticalMargin));
		view.frame		= frame;
		
	}];
	
	NSInteger numberOfPages			= self.numberOfPagesForActivities;
	self.scrollView.contentSize		= CGSizeMake((numberOfPages) * CGRectGetWidth(self.frame), CGRectGetHeight(self.scrollView.frame));
	self.scrollView.pagingEnabled	= YES;
	
	CGRect pageControlFrame			= self.pageControl.frame;
	pageControlFrame.origin.y		= CGRectGetMaxY(self.frame) - CGRectGetHeight(pageControlFrame);
	pageControlFrame.size.width		= CGRectGetWidth(self.frame);
	self.pageControl.frame			= pageControlFrame;
	self.pageControl.numberOfPages	= numberOfPages;
	
	if (self.pageControl.numberOfPages <= 1) {
		self.pageControl.hidden = YES;
		self.scrollView.scrollEnabled = NO;
	} else {
		self.pageControl.hidden = NO;
		self.scrollView.scrollEnabled = YES;
	}
	
	[self pageControlValueChanged:self.pageControl];
	
}

#pragma mark -
#pragma mark Button action

- (void)buttonPressed:(UIButton *)button {
	
    MHActivity *activity = [self.activities objectAtIndex:button.superview.tag - 1];
    activity.activityViewController = self.activityViewController;
	
    [activity prepareWithActivityItems:self.activityItems];
	[activity performActivity];
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
	
}

#pragma mark -

- (void)pageControlValueChanged:(UIPageControl *)pageControl {
	
    CGFloat pageWidth	= self.scrollView.contentSize.width /self.pageControl.numberOfPages;
    CGFloat x			= self.pageControl.currentPage * pageWidth;
    [self.scrollView scrollRectToVisible:CGRectMake(x, 0, pageWidth, self.scrollView.frame.size.height) animated:YES];
	
}

@end
