//
//  MHRequestOptions.m
//  MissionHub
//
//  Created by Michael Harrison on 6/19/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHRequestOptions.h"

//orientation macros
#define UIDeviceOrientationIsPortrait(orientation)  ((orientation) == UIDeviceOrientationPortrait || (orientation) == UIDeviceOrientationPortraitUpsideDown)
#define UIDeviceOrientationIsLandscape(orientation) ((orientation) == UIDeviceOrientationLandscapeLeft || (orientation) == UIDeviceOrientationLandscapeRight)

// check device orientation
#define dDeviceOrientation [[UIDevice currentDevice] orientation]
#define isPortrait  UIDeviceOrientationIsPortrait(dDeviceOrientation)
#define isLandscape UIDeviceOrientationIsLandscape(dDeviceOrientation)
#define isFaceUp    dDeviceOrientation == UIDeviceOrientationFaceUp   ? YES : NO
#define isFaceDown  dDeviceOrientation == UIDeviceOrientationFaceDown ? YES : NO

//check device type
#define isPad    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO
#define isPhone    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? YES : NO

@implementation MHRequestOptions

@synthesize endpoint	= _endpoint;
@synthesize remoteID	= _remoteID;
@synthesize filters		= _filters;
@synthesize includes	= _includes;
@synthesize limit		= _limit;
@synthesize offset		= _offset;
@synthesize order		= _order;

@synthesize successBlock	= _successBlock;
@synthesize failBlock		= _failBlock;

-(id)init {
	
	self = [super init];
	
	if (self) {
		
		[self reset];
		
	}
	
	return self;
}

-(id)reset {
	
	self.endpoint	= MHRequestOptionsEndpointPeople;
	self.remoteID	= 0;
	self.filters	= [NSDictionary dictionary];
	self.includes	= [NSMutableIndexSet indexSet];
	self.limit		= 0;
	self.offset		= 0;
	self.order		= MHRequestOptionsOrderNone;
	
	self.successBlock		= nil;
	self.failBlock			= nil;
	
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

-(id)configureForInitialPeoplePage {
	
	[[[self reset] addIncludesForProfileRequest] setLimitAndOffsetForFirstPage];
	
	return self;
}

-(id)configureForMeRequest {
	
	[[self reset] addIncludesForMeRequest];
	
	return self;
}

-(id)configureForOrganizationRequestWithRemoteID:(NSNumber *)remoteID {
	
	[[self reset] addIncludesForOrganizationRequest];
	self.endpoint = MHRequestOptionsEndpointOrganizations;
	self.remoteID = [remoteID integerValue];
	
	return self;
}

-(id)configureForProfileRequestWithRemoteID:(NSNumber *)remoteID {
	
	[[self reset] addIncludesForProfileRequest];
	self.remoteID = [remoteID integerValue];
	
	return self;
}

-(id)configureForNextPageRequest {
	
	[self setLimitAndOffsetForNextPage];
	
	return self;
}

-(id)addInclude:(MHRequestOptionsIncludes)include {
	
	[self.includes addIndex:include];
	
	return self;
	
}

-(id)addIncludesForProfileRequest {
	
	
	//[self addInclude:MHRequestOptionsIncludePeopleInteractions];
	[self addInclude:MHRequestOptionsIncludePeopleOrganizationalPermissions];
	[self addInclude:MHRequestOptionsIncludeOrganizationalPermissionsPermission];
	[self addInclude:MHRequestOptionsIncludePeopleOrganizationalLabels];
	[self addInclude:MHRequestOptionsIncludeOrganizationalLabelsLabel];
	[self addInclude:MHRequestOptionsIncludePeopleEmailAddresses];
	[self addInclude:MHRequestOptionsIncludePeoplePhoneNumbers];
	[self addInclude:MHRequestOptionsIncludePeopleAddresses];
	//[self addInclude:MHRequestOptionsIncludeInteractionsCreator];
	//[self addInclude:MHRequestOptionsIncludeInteractionsInitiators];
	//[self addInclude:MHRequestOptionsIncludeInteractionsInteractionType];
	//[self addInclude:MHRequestOptionsIncludeInteractionsLastUpdater];
	
	
	return self;
}

-(id)addIncludesForPeoplePageRequest {
	
	
	[self addInclude:MHRequestOptionsIncludePeopleOrganizationalPermissions];
	[self addInclude:MHRequestOptionsIncludePeopleOrganizationalLabels];
	[self addInclude:MHRequestOptionsIncludePeopleEmailAddresses];
	[self addInclude:MHRequestOptionsIncludePeoplePhoneNumbers];
	
	
	return self;
}

-(id)addIncludesForOrganizationRequest {
	
	[self addInclude:MHRequestOptionsIncludeOrganizationsAdmins];
	[self addInclude:MHRequestOptionsIncludeOrganizationsLeaders];
	[self addInclude:MHRequestOptionsIncludeOrganizationsSurveys];
	[self addInclude:MHRequestOptionsIncludeOrganizationsLabels];
	[self addInclude:MHRequestOptionsIncludeOrganizationsAllQuestions];
	
	return self;
}

-(id)addIncludesForMeRequest {
	
	[self addIncludesForProfileRequest];
	[self addInclude:MHRequestOptionsIncludePeopleAllOrganizationsAndChildren];
	[self addInclude:MHRequestOptionsIncludePeopleAllOrganizationalPermissions];
	[self addInclude:MHRequestOptionsIncludePeopleUser];
	
	return self;
}

-(id)setLimitAndOffsetForFirstPage {
	
	self.offset = 0;
	
	if (isPad) {
		
		if (isPortrait) {
			
			self.limit = 30;
			
		} else {
			
			self.limit = 20;
			
		}
		
	} else {
		
		if (isPortrait) {
			
			self.limit = 20;
			
		} else {
			
			self.limit = 10;
			
		}
		
	}
	
	return self;
}

-(id)setLimitAndOffsetForNextPage {
	
	self.offset += self.limit;
	
	if (isPad) {
		
		if (isPortrait) {
			
			self.limit = 30;
			
		} else {
			
			self.limit = 20;
			
		}
		
	} else {
		
		if (isPortrait) {
			
			self.limit = 20;
			
		} else {
			
			self.limit = 10;
			
		}
		
	}
	
	return self;
}

-(id)clearIncludes {
	
	[self.includes removeAllIndexes];
	
	return self;
}

-(id)addFilter:(MHRequestOptionsFilters)filter withValue:(NSString *)value {
	
	[self.filters setValue:value forKey:[self stringFromFilter:filter]];
	
	return self;
}

-(id)updateFilter:(MHRequestOptionsFilters)filter withValue:(NSString *)value {
	
	[self.filters setValue:value forKey:[self stringFromFilter:filter]];
	
	return self;
}

-(id)removeFilter:(MHRequestOptionsFilters)filter {
	
	[self.filters removeObjectForKey:[self stringFromFilter:filter]];
	
	return self;
}

-(id)clearFilters {
	
	[self.filters removeAllObjects];
	
	return self;
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
		case MHRequestOptionsFilterPeopleLabels:
			filterString = @"labels";
			break;
		case MHRequestOptionsFilterPeoplePermissions:
			filterString = @"permissions";
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
		case MHRequestOptionsIncludeOrganizationsLeaders:
			includeString = @"leaders";
			break;
		case MHRequestOptionsIncludeOrganizationsLabels:
			includeString = @"labels";
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
		case MHRequestOptionsIncludePeopleAnswerSheets:
			includeString = @"answer_sheets";
			break;
		case MHRequestOptionsIncludePeopleOrganizationalLabels:
			includeString = @"organizational_labels";
			break;
		case MHRequestOptionsIncludePeoplePhoneNumbers:
			includeString = @"phone_numbers";
			break;
		case MHRequestOptionsIncludePeoplePersonTransfers:
			includeString = @"person_transfers";
			break;
		case MHRequestOptionsIncludePeopleAddresses:
			includeString = @"addresses";
			break;
		case MHRequestOptionsIncludePeopleUser:
			includeString = @"user";
			break;
		case MHRequestOptionsIncludeSurveysKeywords:
			includeString = @"keywords";
			break;
		case MHRequestOptionsIncludeSurveysQuestions:
			includeString = @"questions";
			break;
		case MHRequestOptionsIncludeOrganizationsAllQuestions:
			includeString = @"all_questions";
			break;
		case MHRequestOptionsIncludeOrganizationalLabelsLabel:
			includeString = @"label";
			break;
		case MHRequestOptionsIncludeOrganizationalPermissionsPermission:
			includeString = @"permission";
			break;
		case MHRequestOptionsIncludeInteractionsCreator:
			includeString = @"creator";
			break;
		case MHRequestOptionsIncludeInteractionsInitiators:
			includeString = @"initiators";
			break;
		case MHRequestOptionsIncludeInteractionsInteractionType:
			includeString = @"interaction_type";
			break;
		case MHRequestOptionsIncludeInteractionsLastUpdater:
			includeString = @"last_updater";
			break;
		case MHRequestOptionsIncludeInteractionsReceiver:
			includeString = @"receiver";
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
