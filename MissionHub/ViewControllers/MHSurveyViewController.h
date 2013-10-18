//
//  MHSurveyViewController.h
//  MissionHub
//
//  Created by Michael Harrison on 6/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MHMenuViewController.h"
#import "MHSurvey.h"


@interface MHSurveyViewController : UIViewController <UIWebViewDelegate>

- (id)displaySurvey:(MHSurvey *)surveyToDisplay;

@end
