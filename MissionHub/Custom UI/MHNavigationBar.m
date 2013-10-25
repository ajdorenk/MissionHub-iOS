//
//  MHNavigationBar.m
//  MissionHub
//
//  Created by Michael Harrison on 10/24/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHNavigationBar.h"

static CGFloat const kDefaultColorLayerOpacity = 0.5f;
static CGFloat const kSpaceToCoverStatusBars = 20.0f;

@interface MHNavigationBar ()

@property (nonatomic, strong) CALayer *colorLayer;

- (void)configure;

@end

@implementation MHNavigationBar

- (id)initWithFrame:(CGRect)frame {
	
    self = [super initWithFrame:frame];
	
    if (self) {
		
        // Initialization code
		[self configure];
		
    }
	
    return self;
}

- (void)awakeFromNib {
	
	[super awakeFromNib];
	
	[self configure];
	
}

- (void)configure {
	
	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
		
		UIImage *navBackground =[[UIImage imageNamed:@"MH_Mobile_Topbar_Background.png"]
								 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
		[self setBackgroundImage:navBackground forBarMetrics:UIBarMetricsDefault];
		
	} else {
		
		self.barTintColor	= [UIColor whiteColor];
		
	}
	
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    [super setBarTintColor:barTintColor];
    if (self.colorLayer == nil) {
        self.colorLayer = [CALayer layer];
        self.colorLayer.opacity = kDefaultColorLayerOpacity;
        [self.layer addSublayer:self.colorLayer];
    }
    self.colorLayer.backgroundColor = barTintColor.CGColor;
}

- (void)layoutSubviews {
	
    [super layoutSubviews];
    
	if (self.colorLayer != nil) {
        self.colorLayer.frame = CGRectMake(0, 0 - kSpaceToCoverStatusBars, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + kSpaceToCoverStatusBars);
		
        [self.layer insertSublayer:self.colorLayer atIndex:1];
    }
	
}

@end
