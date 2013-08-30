//
//  MHAnswerSheet+Helper.h
//  MissionHub
//
//  Created by Michael Harrison on 8/23/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAnswerSheet.h"
#import "MHAnswer.h"

@interface MHAnswerSheet (Helper)

+ (NSDateFormatter *)dateFormatter;
- (NSString *)updatedAtString;

@end
