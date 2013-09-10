//
//  MHParallaxTopViewController.h
//  MissionHub
//
//  Created by Amarisa Robison on 6/27/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHPerson+Helper.h"
#import "MHProfileProtocol.h"

@interface MHProfileHeaderViewController : UIViewController <UIScrollViewDelegate, MHProfileProtocol>

-(void)setProfileImageWithUrl:(NSString *)urlString;
-(void)setName:(NSString *)nameString;
-(void)setLabelListWithSetOfOrganizationalLabels:(NSSet *)organizationalLabels;

-(void)updateLayout;

@end
