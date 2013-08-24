//
//  MHAnswer.h
//  MissionHub
//
//  Created by Michael Harrison on 8/23/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MHModel.h"

@class MHAnswerSheet;

@interface MHAnswer : MHModel

@property (nonatomic, retain) NSNumber * remoteID;
@property (nonatomic, retain) NSNumber * question_id;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) MHAnswerSheet *answerSheet;

@end
