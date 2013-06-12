//
//  MHLoginViewController.h
//  MissionHub
//
//  Created by Michael Harrison on 6/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

@protocol MHLoginDelegate <NSObject>
@optional

-(void)loggedInWithToken:(NSString *)token;
-(void)loggedOut;

@end

@interface MHLoginViewController : UIViewController <FBLoginViewDelegate, MHLoginDelegate>

@property (nonatomic, retain)				id<MHLoginDelegate> delegate;
@property (unsafe_unretained, nonatomic)	IBOutlet FBLoginView *FBLoginView;

@end
