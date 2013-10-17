//
//  MHSurvey+Helper.m
//  MissionHub
//
//  Created by Michael Harrison on 7/26/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHSurvey+Helper.h"

@implementation MHSurvey (Helper)

-(void)setRelationshipsObject:(id)relationshipObject forFieldName:(NSString *)fieldName {
	
	if ([fieldName isEqualToString:@"all_questions"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		__weak __typeof(&*self)weakSelf = self;
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHQuestion *newObject = [MHQuestion newObjectFromFields:object];
			
			[weakSelf addQuestionsObject:newObject];
			
		}];
		
	}
	
}

@end
