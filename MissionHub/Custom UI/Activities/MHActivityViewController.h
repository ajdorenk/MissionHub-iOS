//
//  MHActivityViewController.h
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

#import <UIKit/UIKit.h>
#import "MHActivityView.h"
#import "MHActivities.h"

typedef enum {
	MHActivityViewControllerAnimationDirectionUp,
	MHActivityViewControllerAnimationDirectionDown,
} MHActivityViewControllerAnimationDirection;

typedef enum {
	MHActivityViewControllerAnimationPositionTop,
	MHActivityViewControllerAnimationPositionBottom,
} MHActivityViewControllerAnimationPosition;

@protocol MHActivityViewControllerDelegate;

@interface MHActivityViewController : UIViewController

@property (nonatomic, weak) id<MHActivityViewControllerDelegate> delegate;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong, readonly) NSArray *activities;
@property (nonatomic, strong) NSArray *activityItems;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) MHActivityView *activityView;
@property (nonatomic, weak) UIViewController *presentingController;
@property (nonatomic, strong) UIView *animateFromView;
@property (nonatomic, assign) MHActivityViewControllerAnimationPosition animationPosition;
@property (nonatomic, assign) MHActivityViewControllerAnimationDirection animationDirection;

+ (NSArray *)allActivities;

- (id)initWithViewController:(UIViewController *)viewController activityItems:(NSArray *)activityItems activities:(NSArray *)activities;
- (void)presentFromRootViewController;
- (void)presentFromViewController:(UIViewController *)controller;

@end

@protocol MHActivityViewControllerDelegate <NSObject>

@optional
- (void)activityDidFinish:(NSString *)activityType completed:(BOOL)completed;

@end
