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
		
		[self.attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			
			if ([key isEqualToString:@"remoteID"]) {
				
				[self.attributes setValue:@"id" forKey:key];
				
			} else {
				
				[self.attributes setValue:key forKey:key];
				
			}
			
		}];
		
		/*
		self.relationships			= [ent relationshipsByName];
		
		[self.relationships enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			
			[self.relationships setValue:key forKey:key];
			
		}];
		*/
	}
	
	return self;
	
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
	
	NSManagedObjectContext *contextForCreation = context ? context : [[MHStorage sharedInstance] managedObjectContext];
	id newObject = [[self alloc] initWithEntity:[self entityFromName:entityName] insertIntoManagedObjectContext:contextForCreation];
	
	[newObject setFields:fields];
	
	return newObject;
}

-(void)setFields:(NSDictionary *)fields {
	
	
	
	if (fields != nil) {
		
		for (NSString *fieldName in fields) {
			
			if ([self.attributes objectForKey:fieldName]) {
				
				[self setValue:[fields objectForKey:fieldName] forKey:[self.attributes objectForKey:fieldName]];
				
			} else {
				
				[self setRelationshipsObject:[fields objectForKey:fieldName] forFieldName:fieldName];
				
			}
			
		}
		
	}
	
}

-(void)setValue:(id)value forKey:(NSString *)key {
	
	id formattedValue = value;
	
	if ([key isEqualToString:@"created_at"] ||
		[key isEqualToString:@"updated_at"] ||
		[key isEqualToString:@"deleted_at"] ||
		[key isEqualToString:@"timestamp"]) {
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
		formattedValue = [dateFormatter dateFromString:value];
		
	} else if ([key isEqualToString:@"birth_date"] ||
			   [key isEqualToString:@"date_became_christian"] ||
			   [key isEqualToString:@"graduation_date"]) {
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
		formattedValue = [dateFormatter dateFromString:value];
		
	}
	
	[super setValue:formattedValue forKey:key];
	
}

-(id)valueForKey:(NSString *)key {
	
	id value = [super valueForKey:key];
	
	if ([key isEqualToString:@"created_at"] ||
		[key isEqualToString:@"updated_at"] ||
		[key isEqualToString:@"deleted_at"] ||
		[key isEqualToString:@"timestamp"]) {
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
		value = [dateFormatter stringFromDate:value];
		
	} else if ([key isEqualToString:@"birth_date"] ||
			   [key isEqualToString:@"date_became_christian"] ||
			   [key isEqualToString:@"graduation_date"]) {
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
		value = [dateFormatter stringFromDate:value];
		
	}
	
	return value;
	
}

-(void)setRelationshipsObject:(id)relationshipObject forFieldName:(NSString *)fieldName {
	
	//should be subclassed to deal with relationships
	
}

@end
