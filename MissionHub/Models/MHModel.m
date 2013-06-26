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

-(void)setRelationshipsObject:(id)relationshipObject forFieldName:(NSString *)fieldName {
	
	//should be subclassed to deal with relationships
	
}

@end
