//
//  MHWelcomePanel.m
//  MissionHub
//
//  Created by Michael Harrison on 11/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHWelcomePanel.h"

@interface MHWelcomePanel ()

@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UIView *topView;
@property (nonatomic, weak) IBOutlet UIView *backgroundView;
@property (nonatomic, assign) CGRect		originalFrame;

- (void)configure;

@end

@implementation MHWelcomePanel

- (id)initWithFrame:(CGRect)frame {
	
    self = [super initWithFrame:frame];
	
    if (self) {
        
		[self configure];
		
    }
	
    return self;
}

- (void)awakeFromNib {
	
	[super awakeFromNib];
	
	[self configure];
	
}

- (void)configure {
	
	self.topView.alpha					= 1.0;
    self.topView.layer.cornerRadius		= 20;
    self.topView.clipsToBounds			= YES;
	
	self.bottomView.alpha				= 1.0;
    self.bottomView.layer.cornerRadius	= 20;
    self.bottomView.clipsToBounds		= YES;
	
	self.backgroundView.autoresizingMask= UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	
	self.originalFrame					= self.topView.frame;
	
}

#pragma mark - Interaction Methods
//Override them if you want them!

- (void)panelDidAppear {
	
	self.topView.frame				= CGRectMake(self.topView.center.x, self.topView.center.y, 0, 0);
	
	__weak __typeof(&*self)weakSelf = self;
	[UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		
		weakSelf.backgroundView.alpha	= 0.0;
		weakSelf.bottomView.alpha		= 0.0;
		weakSelf.topView.alpha			= 1.0;
		weakSelf.topView.frame			= weakSelf.originalFrame;
		
	} completion:nil];
	
}

- (void)panelDidDisappear {
	
	//self.backgroundView.alpha	= 1.0;
	//self.bottomView.alpha		= 1.0;
	self.topView.alpha			= 0.0;
	self.topView.frame			= self.originalFrame;
	
}

@end
