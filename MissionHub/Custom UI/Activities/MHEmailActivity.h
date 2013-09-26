//
//  MHEmailActivity.h
//  MissionHub
//
//  Created by Michael Harrison on 9/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHActivity.h"
#import <MessageUI/MessageUI.h>

extern NSString * const MHActivityTypeEmail;

@interface MHEmailActivity : MHActivity <MFMailComposeViewControllerDelegate>

@end
