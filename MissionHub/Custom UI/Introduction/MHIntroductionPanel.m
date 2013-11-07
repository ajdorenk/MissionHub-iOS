//
//  MHIntroductionPanel.m
//  MissionHub
//
//  Created by Michael Harrison on 11/4/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHIntroductionPanel.h"

@interface MHIntroductionPanel ()

@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UIView *topView;

- (void)configure;

@end

@implementation MHIntroductionPanel

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
	
	self.topView.alpha					= 0.0;
    self.topView.layer.cornerRadius		= 60;
    self.topView.clipsToBounds			= YES;
	
	self.bottomView.alpha				= 1.0;
    self.bottomView.layer.cornerRadius	= 60;
    self.bottomView.clipsToBounds		= YES;
	
}

#pragma mark - Interaction Methods
//Override them if you want them!

- (void)panelDidAppear {
	
	__weak __typeof(&*self)weakSelf = self;
	[UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		
		weakSelf.topView.alpha		= 1.0;
		
	} completion:nil];
	
}

- (void)panelDidDisappear {
	
	self.bottomView.alpha	= 1.0;
	self.topView.alpha		= 0.0;
	
}

@end
