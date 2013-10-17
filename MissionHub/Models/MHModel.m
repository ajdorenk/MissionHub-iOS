//
//  MHModel.m
//  MissionHub
//
//  Created by Michael Harrison on 6/16/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHModel.h"

@implementation MHModel

@synthesize attributes		= _attributes;
//@synthesize relationships	= _relationships;

-(id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
	
	self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
	
	if (self) {
		
		//grab the entity or if it is nil grab the enitity description from the class name
		NSEntityDescription *ent	= ( entity ? entity : [self entity] );
		
		self.attributes				= [ent attributesByName];
		
		__weak __typeof(&*self)weakSelf = self;
		[self.attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			
			if ([key isEqualToString:@"remoteID"]) {
				
				[weakSelf.attributes setValue:@"id" forKey:key];
				
			} else {
				
				[weakSelf.attributes setValue:key forKey:key];
				
			}
			
		}];
		
		/*
		self.relationships			= [ent relationshipsByName];
		
		[self.relationships enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			
			[weakSelf.relationships setValue:key forKey:key];
			
		}];
		*/
		
		[self setDefaults];
		
	}
	
	return self;
	
}

-(void)setDefaults {
	
}

-(BOOL)isEqualToModel:(id)model {
	
	if ([model isKindOfClass:[self class]]) {
		
		return [[self valueForKey:@"remoteID"] isEqualToNumber:[model valueForKey:@"remoteID"]];
		
	} else {
		
		return NO;
		
	}
	
}

-(NSString *)displayString {
	return @"";
}

+(NSEntityDescription *)entity {
	
	return [self entityFromName:nil];
	
}

+(NSEntityDescription *)entityFromName:(NSString *)name {
	
	NSString *entityName = name ? name : NSStringFromClass([self class]);
	
	return [[[[MHStorage sharedInstance] managedObjectModel] entitiesByName] objectForKey:entityName];
	
}

+(NSFetchRequest *)fetchRequestForEntity {
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[self entity]];
	
	return fetchRequest;
}

+(id)newObjectFromFields:(NSDictionary *)fields {
	
	return [self newObjectForEntityName:nil fromFields:(NSDictionary *)fields inContext:nil];
	
}

+(id)newObjectForClass:(NSString *)className fromFields:(NSDictionary *)fields {
	
	return [self newObjectForEntityName:className fromFields:(NSDictionary *)fields inContext:nil];
	
}

+(id)newObjectForEntityName:(NSString *)entityName fromFields:(NSDictionary *)fields inContext:(NSManagedObjectContext *)context {
	
	NSString *nameForEntity = entityName ? entityName : NSStringFromClass([self class]);
	NSManagedObjectContext *contextForCreation = context ? context : [[MHStorage sharedInstance] managedObjectContext];
	id newObject = [NSEntityDescription insertNewObjectForEntityForName:nameForEntity inManagedObjectContext:contextForCreation];
	
	[newObject setFields:fields];
	
	return newObject;
}

-(void)setFields:(NSDictionary *)fields {
	
	
	
	if (fields != nil) {
		
		for (NSString *fieldName in fields) {
			
			if ([self.attributes objectForKey:fieldName]) {
				
				if ([[fields objectForKey:fieldName] class] != [NSNull class]) {
					
					[self setValue:[fields objectForKey:fieldName] forKey:[self.attributes objectForKey:fieldName]];
					
				}
				
				
				
			} else {
				
				if ([fieldName isEqualToString:@"id"]) {
					
					if ([[fields objectForKey:fieldName] class] != [NSNull class]) {
						
						[self setValue:[fields objectForKey:fieldName] forKey:@"remoteID"];
						
					}
					
				} else {
				
					[self setRelationshipsObject:[fields objectForKey:fieldName] forFieldName:fieldName];
					
				}
				
			}
			
		}
		
	}
	
}

-(void)setValue:(id)value forKey:(NSString *)key {
	
	
	if ([value isKindOfClass:[NSString class]]) {
	
		
		if ([key isEqualToString:@"created_at"] ||
			[key isEqualToString:@"updated_at"] ||
			[key isEqualToString:@"deleted_at"] ||
			[key isEqualToString:@"completed_at"] ||
			[key isEqualToString:@"timestamp"] ||
			[key isEqualToString:@"email_updated_at"]) {
			
			NSString *formattedValue = value;
			
			if ([value length] > 21) {
				formattedValue = [[value substringToIndex:22] stringByAppendingString:[value substringFromIndex:23]];
			}
			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
			NSDate *dateValue = [dateFormatter dateFromString:formattedValue];
			
			[super setValue:dateValue forKey:key];
			return;
			
		} else if ([key isEqualToString:@"birth_date"] ||
				   [key isEqualToString:@"date_became_christian"] ||
				   [key isEqualToString:@"graduation_date"] ||
				   [key isEqualToString:@"start_date"] ||
				   [key isEqualToString:@"removed_date"] ||
				   [key isEqualToString:@"archive_date"]) {
			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd"];
			NSDate *dateValue = [dateFormatter dateFromString:value];
			
			[super setValue:dateValue forKey:key];
			return;
			
		}
	
		
	}
	
	[super setValue:value forKey:key];
}

-(id)valueForKey:(NSString *)key {
	
	id value = [super valueForKey:key];
	
	if ([value isKindOfClass:[NSDate class]]) {
		
		if ([key isEqualToString:@"created_at"] ||
			[key isEqualToString:@"updated_at"] ||
			[key isEqualToString:@"deleted_at"] ||
			[key isEqualToString:@"timestamp"] ||
			[key isEqualToString:@"email_updated_at"]) {
			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
			NSString *dateString = [dateFormatter stringFromDate:value];
			value = [NSString stringWithFormat:@"%@:%@", [dateString substringToIndex:22], [dateString substringFromIndex:22]];
			
		} else if ([key isEqualToString:@"birth_date"] ||
				   [key isEqualToString:@"date_became_christian"] ||
				   [key isEqualToString:@"graduation_date"] ||
				   [key isEqualToString:@"start_date"] ||
				   [key isEqualToString:@"removed_date"] ||
				   [key isEqualToString:@"archive_date"]) {
			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd"];
			value = [dateFormatter stringFromDate:value];
			
		}
		
	}
	
	return value;
	
}

-(NSString *)fieldNameForJsonObjectWithKey:(NSString *)key {
	
	if ([key isEqualToString:@"remoteID"]) {
		
		return @"id";
		
	} else {
		
		return key;
		
	}
	
}

-(id)valueForJsonObjectWithKey:(NSString *)key {
	
	return [self valueForKey:key];
	
}

-(void)setRelationshipsObject:(id)relationshipObject forFieldName:(NSString *)fieldName {
	
	//should be subclassed to deal with relationships
	
}

-(NSDictionary *)jsonObject {
	
	NSEntityDescription *entity	= [self entity];
	__block NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionary];
	NSDictionary *relationshipDictionary = [entity relationshipsByName];
	
	__weak __typeof(&*self)weakSelf = self;
	[[entity attributesByName] enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
		
		NSString * keyForReturnObject = [weakSelf fieldNameForJsonObjectWithKey:key];
		id returnObject = [weakSelf valueForJsonObjectWithKey:key];
		
		if (returnObject && ![keyForReturnObject isEqualToString:@"id"]) {
			
			[jsonDictionary setObject:returnObject forKey:keyForReturnObject];
			
		}
		
	}];
	
	[relationshipDictionary enumerateKeysAndObjectsUsingBlock:^(id fieldName, id relationshipObject, BOOL *stop) {
		
		if ([fieldName isKindOfClass:[NSString class]]) {
			
			[weakSelf addRelationshipObject:[weakSelf valueForKey:fieldName] forFieldName:fieldName toJsonObject:jsonDictionary];
			
		}
		
	}];
	
	
	return jsonDictionary;
}

-(void)addRelationshipObject:(id)relationshipObject forFieldName:(NSString *)fieldName toJsonObject:(NSMutableDictionary *)jsonObject {
	
	//should be subclassed to deal with relationships
	
}

-(BOOL)validateForServerCreate:(NSError **)error {
	
	return YES;
	
}

-(BOOL)validateForServerUpdate:(NSError **)error {
	
	return YES;
	
}

-(BOOL)validateForServerDelete:(NSError **)error {
	
	return YES;
	
}

@end
