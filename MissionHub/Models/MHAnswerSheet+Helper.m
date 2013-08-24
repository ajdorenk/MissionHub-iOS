//
//  MHAnswerSheet+Helper.m
//  MissionHub
//
//  Created by Michael Harrison on 8/23/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAnswerSheet+Helper.h"

@implementation MHAnswerSheet (Helper)

-(void)setRelationshipsObject:(id)relationshipObject forFieldName:(NSString *)fieldName {
	
	if ([fieldName isEqualToString:@"answers"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHAnswer *newObject = [MHAnswer newObjectFromFields:object];
			
			[self addAnswersObject:newObject];
			
		}];
		
	}
	
}

@end
