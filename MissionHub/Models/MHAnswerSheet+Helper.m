//
//  MHAnswerSheet+Helper.m
//  MissionHub
//
//  Created by Michael Harrison on 8/23/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAnswerSheet+Helper.h"

@implementation MHAnswerSheet (Helper)

+ (NSDateFormatter *)dateFormatter {
	
	static NSDateFormatter *dateFormatterShared;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		
		dateFormatterShared = [[NSDateFormatter alloc] init];
		[dateFormatterShared setDateFormat:@"dd MMM yyyy"];
		
	});
	
	return dateFormatterShared;
	
}

- (NSString *)updatedAtString {
	
	return [[MHAnswerSheet dateFormatter] stringFromDate:self.updated_at];
	
}

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
