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

#import <UIKit/UIKit.h>
#import "MHActivity.h"

extern CGFloat const MHActivityWidth;
extern CGFloat const MHActivityHeight;
extern CGFloat const MHActivityViewVerticalMargin;
extern CGFloat const MHActivityViewHorizontalMargin;
extern NSUInteger const MHActivityViewMaxRowPerPage;
extern CGFloat const MHActivityImageWidth;
extern CGFloat const MHActivityImageHeight;
extern CGFloat const MHActivityLabelWidth;
extern CGFloat const MHActivityLabelHeight;
extern CGFloat const MHActivityPageControlHeight;

@interface MHActivityView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *activities;
@property (nonatomic, strong) NSArray *activityItems;
@property (nonatomic, weak) MHActivityViewController *activityViewController;
@property (nonatomic, assign) NSUInteger maxRowsPerPage;
@property (nonatomic, assign) NSUInteger maxColumnsPerPage;


- (id)initWithFrame:(CGRect)frame activityItems:(NSArray *)activityItems activities:(NSArray *)activities;

@end
