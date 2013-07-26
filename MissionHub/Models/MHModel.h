//
//  MHModel.h
//  MissionHub
//
//  Created by Michael Harrison on 6/16/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MHStorage.h"
#import "NSSet+MHSearchForRemoteID.h"

@interface MHModel : NSManagedObject {
	
	NSDictionary *_attributes;
	//NSDictionary *_relationships;
	
}

@property (nonatomic, strong) NSDictionary *attributes;
//@property (nonatomic, strong) NSDictionary *relationships;


-(NSString *)displayString;

+(NSEntityDescription *)entity;
+(NSEntityDescription *)entityFromName:(NSString *)name;

+(NSFetchRequest *)fetchRequestForEntity;

+(id)newObjectFromFields:(NSDictionary *)fields;
+(id)newObjectForClass:(NSString *)className fromFields:(NSDictionary *)fields;
+(id)newObjectForEntityName:(NSString *)entityName fromFields:(NSDictionary *)fields inContext:(NSManagedObjectContext *)context;

//will take a dictionary of remote fields and values and will set the local attributes to those values using self.attributes to match remote to local. If your remote field names don't match your local attribute names you should set self.attributes = @{<remote field name>: <local attribute name>, ...}.
-(void)setFields:(NSDictionary *)fields;
//should be overwirtten with subclasses with relationships.
-(void)setRelationshipsObject:(id)relationshipObject forFieldName:(NSString *)fieldName;

//is used to construct json object. please overide if you need a different fieldname from the attribute key in your json object
-(NSString *)fieldNameForJsonObjectWithKey:(NSString *)key;
//is used to construct the json object. please overide if you need to change the value before it is added to the json object.
-(id)valueForJsonObjectWithKey:(NSString *)key;

-(NSDictionary *)jsonObject;
//should be overwirtten with subclasses with relationships.
-(void)addRelationshipObject:(id)relationshipObject forFieldName:(NSString *)fieldName toJsonObject:(NSMutableDictionary *)jsonObject;

@end
