//
//  MHAnswerSheet.h
//  MissionHub
//
//  Created by Michael Harrison on 8/23/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MHModel.h"

@class MHPerson, MHAnswer;

@interface MHAnswerSheet : MHModel

@property (nonatomic, retain) NSNumber * remoteID;
@property (nonatomic, retain) NSNumber * survey_id;
@property (nonatomic, retain) NSDate * completed_at;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSSet *answers;
@property (nonatomic, retain) MHPerson *person;
@end

@interface MHAnswerSheet (CoreDataGeneratedAccessors)

- (void)addAnswersObject:(MHAnswer *)value;
- (void)removeAnswersObject:(MHAnswer *)value;
- (void)addAnswers:(NSSet *)values;
- (void)removeAnswers:(NSSet *)values;

@end
