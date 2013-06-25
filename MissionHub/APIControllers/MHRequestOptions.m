//
//  MHRequestOptions.m
//  MissionHub
//
//  Created by Michael Harrison on 6/19/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHRequestOptions.h"

@implementation MHRequestOptions

@synthesize endpoint	= _endpoint;
@synthesize remoteID	= _remoteID;
@synthesize filters		= _filters;
@synthesize includes	= _includes;
@synthesize limit		= _limit;
@synthesize offset		= _offset;
@synthesize order		= _order;

-(id)init {
	
	self = [super init];
	
	if (self) {
		
		self.endpoint	= MHRequestOptionsEndpointPeople;
		self.remoteID	= 0;
		self.filters	= [NSDictionary dictionary];
		self.includes	= [NSMutableIndexSet indexSet];
		self.limit		= 0;
		self.offset		= 0;
		self.order		= MHRequestOptionsOrderNone;
		
	}
	
	return self;
}

-(BOOL)hasRemoteID {
	return (self.remoteID > 0);
}

-(BOOL)hasFilters {
	return ([self.filters count] > 0);
}

-(BOOL)hasIncludes {
	return ([self.includes count] > 0);
}

-(BOOL)hasLimit {
	return (self.limit > 0);
}

-(BOOL)hasOffset {
	return (self.offset > 0);
}

-(BOOL)hasOrder {
	return (self.order != MHRequestOptionsOrderNone);
}

-(void)addInclude:(MHRequestOptionsIncludes)include {
	
	[self.includes addIndex:include];
	
}

-(void)clearIncludes {
	
	[self.includes removeAllIndexes];
	
}

-(void)addFilter:(MHRequestOptionsFilters)filter withValue:(NSString *)value {
	
	[self.filters setValue:value forKey:[self stringFromFilter:filter]];
	
}

-(void)updateFilter:(MHRequestOptionsFilters)filter withValue:(NSString *)value {
	
	[self.filters setValue:value forKey:[self stringFromFilter:filter]];
	
}

-(void)removeFilter:(MHRequestOptionsFilters)filter {
	
	[self.filters removeObjectForKey:[self stringFromFilter:filter]];
	
}

-(void)clearFilters {
	
	[self.filters removeAllObjects];
	
}

-(NSString *)stringForEndpoint {
	return [self stringFromEndpoint:self.endpoint];
}

-(NSString *)stringInSingluarFormatForEndpoint {
	return [self stringInSingluarFormatFromEndpoint:self.endpoint];
}

-(NSString *)stringForIncludes {
	
	__block NSString * includeString = @"";
	
	[self.includes enumerateIndexesUsingBlock:^(MHRequestOptionsIncludes include, BOOL *stop) {
		
		includeString = [includeString stringByAppendingFormat:@"%@,", [self stringFromInclude:include]];
		
	}];
	
	//remove last comma from the end of the string
	includeString = [includeString substringToIndex:[includeString length] - 1];
	
	return includeString;
}

-(NSString *)stringForFilters {
	
	__block NSString * filterString = @"";
	
	[self.filters enumerateKeysAndObjectsUsingBlock:^(NSString *filter, NSString *value, BOOL *stop) {
		
		filterString = [filterString stringByAppendingFormat:@"&filters[%@]=%@", filter, value];
		
	}];
	
	//remove first & from the start of the string
	filterString = [filterString substringFromIndex:1];
	
	return filterString;
	
}

-(NSString *)stringForLimit {
	return [NSNumber numberWithInteger:self.limit].stringValue;
}

-(NSString *)stringForOffset {
	return [NSNumber numberWithInteger:self.offset].stringValue;
}

-(NSString *)stringForOrder {
	return [self stringFromOrder:self.order];
}

-(NSString *)stringFromEndpoint:(MHRequestOptionsEndpoints)endpoint {
	
	NSString *endpointString;
	
	switch (endpoint) {
		case MHRequestOptionsEndpointAnswers:
			endpointString = @"answers";
			break;
		case MHRequestOptionsEndpointContactAssignments:
			endpointString = @"contact_assignments";
			break;
		case MHRequestOptionsEndpointInteractions:
			endpointString = @"interactions";
			break;
		case MHRequestOptionsEndpointInteractionTypes:
			endpointString = @"interaction_types";
			break;
		case MHRequestOptionsEndpointLabels:
			endpointString = @"labels";
			break;
		case MHRequestOptionsEndpointOrganizationalLabels:
			endpointString = @"organizational_labels";
			break;
		case MHRequestOptionsEndpointOrganizationalPermissions:
			endpointString = @"organizational_permissions";
			break;
		case MHRequestOptionsEndpointOrganizations:
			endpointString = @"organizations";
			break;
		case MHRequestOptionsEndpointPeople:
			endpointString = @"people";
			break;
		case MHRequestOptionsEndpointPermissions:
			endpointString = @"permissions";
			break;
		case MHRequestOptionsEndpointQuestions:
			endpointString = @"questions";
			break;
		case MHRequestOptionsEndpointSurveys:
			endpointString = @"surveys";
			break;
			
		default:
			break;
	}
	
	return endpointString;
	
}

-(NSString *)stringInSingluarFormatFromEndpoint:(MHRequestOptionsEndpoints)endpoint {
	
	NSString *endpointString;
	
	switch (endpoint) {
		case MHRequestOptionsEndpointAnswers:
			endpointString = @"answer";
			break;
		case MHRequestOptionsEndpointContactAssignments:
			endpointString = @"contact_assignment";
			break;
		case MHRequestOptionsEndpointInteractions:
			endpointString = @"interaction";
			break;
		case MHRequestOptionsEndpointInteractionTypes:
			endpointString = @"interaction_type";
			break;
		case MHRequestOptionsEndpointLabels:
			endpointString = @"label";
			break;
		case MHRequestOptionsEndpointOrganizationalLabels:
			endpointString = @"organizational_label";
			break;
		case MHRequestOptionsEndpointOrganizationalPermissions:
			endpointString = @"organizational_permission";
			break;
		case MHRequestOptionsEndpointOrganizations:
			endpointString = @"organization";
			break;
		case MHRequestOptionsEndpointPeople:
			endpointString = @"person";
			break;
		case MHRequestOptionsEndpointPermissions:
			endpointString = @"permission";
			break;
		case MHRequestOptionsEndpointQuestions:
			endpointString = @"question";
			break;
		case MHRequestOptionsEndpointSurveys:
			endpointString = @"survey";
			break;
			
		default:
			break;
	}
	
	return endpointString;
	
}


-(NSString *)stringFromFilter:(MHRequestOptionsFilters)filter {
	
	NSString *filterString;
	
	switch (filter) {
		case MHRequestOptionsFilterPeopleEmailLike:
			filterString = @"email_like";
			break;
		case MHRequestOptionsFilterPeopleFirstNameLike:
			filterString = @"first_name_like";
			break;
		case MHRequestOptionsFilterPeopleLastNameLike:
			filterString = @"last_name_like";
			break;
		case MHRequestOptionsFilterPeopleNameLike:
			filterString = @"name_like";
			break;
		case MHRequestOptionsFilterPeopleNameOrEmailLike:
			filterString = @"name_or_email_like";
			break;
		case MHRequestOptionsFilterPeopleRoles:
			filterString = @"roles";
			break;
		case MHRequestOptionsFilterPeopleSurveys:
			filterString = @"surveys";
			break;
			
		default:
			break;
	}
	
	return filterString;
	
}

-(NSString *)stringFromInclude:(MHRequestOptionsIncludes)include {
	
	NSString *includeString;
	
	switch (include) {
		case MHRequestOptionsIncludeConactAssignmentsAssignedTo:
			includeString = @"assigned_to";
			break;
		case MHRequestOptionsIncludeConactAssignmentsPerson:
			includeString = @"person";
			break;
		case MHRequestOptionsIncludeOrganizationsAdmins:
			includeString = @"admins";
			break;
		case MHRequestOptionsIncludeOrganizationsKeywords:
			includeString = @"keywords";
			break;
		case MHRequestOptionsIncludeOrganizationsNoPermissions:
			includeString = @"no_permissions";
			break;
		case MHRequestOptionsIncludeOrganizationsPeople:
			includeString = @"people";
			break;
		case MHRequestOptionsIncludeOrganizationsSurveys:
			includeString = @"surveys";
			break;
		case MHRequestOptionsIncludeOrganizationsUsers:
			includeString = @"users";
			break;
		case MHRequestOptionsIncludePeopleAllOrganizationalPermissions:
			includeString = @"all_organizational_permissions";
			break;
		case MHRequestOptionsIncludePeopleAllOrganizationsAndChildren:
			includeString = @"all_organization_and_children";
			break;
		case MHRequestOptionsIncludePeopleAssignTos:
			includeString = @"assigned_tos";
			break;
		case MHRequestOptionsIncludePeopleContactAssignments:
			includeString = @"contact_assignments";
			break;
		case MHRequestOptionsIncludePeopleEmailAddresses:
			includeString = @"email_addresses";
			break;
		case MHRequestOptionsIncludePeopleInteractions:
			includeString = @"interactions";
			break;
		case MHRequestOptionsIncludePeopleOrganizationalPermissions:
			includeString = @"organizational_permissions";
			break;
		case MHRequestOptionsIncludePeoplePeopleAnswerSheets:
			includeString = @"answer_sheets";
			break;
		case MHRequestOptionsIncludePeoplePeopleOrganizationalLabels:
			includeString = @"organizational_labels";
			break;
		case MHRequestOptionsIncludePeoplePhoneNumbers:
			includeString = @"phone_numbers";
			break;
		case MHRequestOptionsIncludePeoplePersonTransfers:
			includeString = @"person_transfers";
			break;
		case MHRequestOptionsIncludeSurveysKeywords:
			includeString = @"assigned_to";
			break;
		case MHRequestOptionsIncludeSurveysQuestions:
			includeString = @"assigned_to";
			break;
		default:
			break;
	}
	
	return includeString;
	
}

-(NSString *)stringFromOrder:(MHRequestOptionsOrders)order {

	NSString *orderString;
	
	switch (order) {
		case MHRequestOptionsOrderAsc:
			orderString = @"asc";
			break;
		case MHRequestOptionsOrderCreatedAt:
			orderString = @"created_at";
			break;
		case MHRequestOptionsOrderDesc:
			orderString = @"desc";
			break;
		case MHRequestOptionsOrderPeopleFirstName:
			orderString = @"first_name";
			break;
		case MHRequestOptionsOrderPeopleLastName:
			orderString = @"last_name";
			break;
		default:
			break;
	}
	
	return orderString;
	
}

@end
