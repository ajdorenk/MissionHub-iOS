//
//  MHRequestOptions.m
//  MissionHub
//
//  Created by Michael Harrison on 6/19/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHRequestOptions.h"
#import "MHContactAssignment+Helper.h"

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

@interface MHRequestOptions ()

- (NSString *)idStringFromPeopleArray:(NSArray *)people;
- (NSString *)idStringFromLabelArray:(NSArray *)labels;
- (BOOL)hasRemoteID;
- (BOOL)hasFilters;
- (BOOL)hasIncludes;
- (BOOL)hasLimit;
- (BOOL)hasOffset;
- (BOOL)hasOrderField;
- (BOOL)hasOrderDirection;
- (BOOL)hasPostParams;

@end

@implementation MHRequestOptions

@synthesize requestName		= _requestName;
@synthesize type			= _type;
@synthesize endpoint		= _endpoint;
@synthesize remoteID		= _remoteID;
@synthesize filters			= _filters;
@synthesize includes		= _includes;
@synthesize limit			= _limit;
@synthesize offset			= _offset;
@synthesize orderField		= _orderField;
@synthesize orderDirection	= _orderDirection;

@synthesize successBlock	= _successBlock;
@synthesize failBlock		= _failBlock;

@synthesize postParams		= _postParams;

- (id)init {
	
	self = [super init];
	
	if (self) {
		
		[self reset];
		
	}
	
	return self;
}

- (instancetype)reset {
	
	self.requestName	= @"";
	self.type			= MHRequestOptionsTypeIndex;
	self.endpoint		= MHRequestOptionsEndpointPeople;
	self.remoteID		= 0;
	
	if (self.filters) {
		[self clearFilters];
	} else {
		self.filters	= [NSMutableDictionary dictionary];
	}
	
	if (self.includes) {
		[self clearIncludes];
	} else {
		self.includes	= [NSMutableIndexSet indexSet];
	}
	
	self.limit			= 0;
	self.offset			= 0;
	[self clearOrders];
	
	self.successBlock	= nil;
	self.failBlock		= nil;
	
	if (self.postParams) {
		[self clearPostParams];
	} else {
		self.postParams	= [NSMutableDictionary dictionary];
	}
	
	self.jsonObject		= nil;
	
	return self;
}

- (instancetype)copy {
	
	MHRequestOptions *returnObject = [[MHRequestOptions alloc] init];
	
	returnObject.requestName	= [self.requestName copy];
	returnObject.type			= self.type;
	returnObject.endpoint		= self.endpoint;
	returnObject.remoteID		= self.remoteID;
	
	returnObject.filters		= [NSMutableDictionary dictionaryWithDictionary:self.filters];
	returnObject.includes		= [[NSMutableIndexSet alloc] initWithIndexSet:self.includes];
	
	returnObject.limit			= self.limit;
	returnObject.offset			= self.offset;
	returnObject.orderField		= self.orderField;
	returnObject.orderDirection	= self.orderDirection;
	
	returnObject.successBlock	= self.successBlock;
	returnObject.failBlock		= self.failBlock;
	
	returnObject.postParams		= [NSMutableDictionary dictionaryWithDictionary:self.postParams];
	
	return returnObject;
}

- (NSString *)path {
	
	NSString *pathString = nil;
	
	switch (self.type) {
			
		case MHRequestOptionsTypeMe:
			
			pathString = [NSString stringWithFormat:@"%@/me", [self stringFromEndpoint:MHRequestOptionsEndpointPeople]];
			break;
			
		case MHRequestOptionsTypeIndex:
		case MHRequestOptionsTypeCreate:
			
			pathString = [self stringForEndpoint];
			break;
			
		case MHRequestOptionsTypeShow:
		case MHRequestOptionsTypeUpdate:
		case MHRequestOptionsTypeDelete:
			
			pathString = [NSString stringWithFormat:@"%@/%lu", [self stringForEndpoint], (unsigned long)[self remoteID]];
			break;
			
		case MHRequestOptionsTypeBulk:
			
			pathString = [NSString stringWithFormat:@"%@/bulk", [self stringForEndpoint]];
			break;
			
		case MHRequestOptionsTypeBulkArchive:
			
			pathString = [NSString stringWithFormat:@"%@/bulk_archive", [self stringForEndpoint]];
			break;
			
		case MHRequestOptionsTypeBulkCreate:
			
			pathString = [NSString stringWithFormat:@"%@/bulk_create", [self stringForEndpoint]];
			break;
			
		case MHRequestOptionsTypeBulkDelete:
			
			pathString = [NSString stringWithFormat:@"%@/bulk_destroy", [self stringForEndpoint]];
			break;
			
		case MHRequestOptionsTypeBulkUpdate:
			
			pathString = [NSString stringWithFormat:@"%@/bulk_update", [self stringForEndpoint]];
			break;
			
		default:
			break;
	}
	
	return pathString;
	
}

- (NSString *)method {
	
	NSString *methodString = nil;
	
	switch (self.type) {
		case MHRequestOptionsTypeMe:
		case MHRequestOptionsTypeShow:
		case MHRequestOptionsTypeIndex:
			methodString = @"GET";
			break;
		case MHRequestOptionsTypeBulk:
		case MHRequestOptionsTypeBulkCreate:
		case MHRequestOptionsTypeBulkArchive:
		case MHRequestOptionsTypeCreate:
			methodString = @"POST";
			break;
		case MHRequestOptionsTypeBulkUpdate:
		case MHRequestOptionsTypeUpdate:
			methodString = @"PUT";
			break;
		case MHRequestOptionsTypeBulkDelete:
		case MHRequestOptionsTypeDelete:
			methodString = @"DELETE";
			break;
			
		default:
			break;
	}
	
	return methodString;
	
}

- (NSMutableDictionary *)parameters {
	
	__block NSMutableDictionary *parametersDictionary = [NSMutableDictionary dictionary];
	
	switch (self.type) {
			
		case MHRequestOptionsTypeMe:
		case MHRequestOptionsTypeShow:
		case MHRequestOptionsTypeDelete:
			
			if ([self hasIncludes]) {
				
				parametersDictionary[@"include"] = [self stringForIncludes];
				
			}
			
			if ([self hasPostParams]) {
				
				[parametersDictionary addEntriesFromDictionary:self.postParams];
				
			}
			
			break;
			
		case MHRequestOptionsTypeIndex:
			
			if ([self hasFilters]) {
				
				__block NSMutableDictionary *filterDictionary = [NSMutableDictionary dictionary];
				[self.filters enumerateKeysAndObjectsUsingBlock:^(NSString *filter, NSString *value, BOOL *stop) {
					
					filterDictionary[filter]		= value;
					
				}];
				
				parametersDictionary[@"filters"]	= filterDictionary;
				
			}
			
			if ([self hasIncludes]) {
				
				parametersDictionary[@"include"] = [self stringForIncludes];
				
			}
			
			if ([self hasLimit]) {
				
				parametersDictionary[@"limit"] = [self stringForLimit];
				
			}
			
			if ([self hasOffset]) {
				
				parametersDictionary[@"offset"] = [self stringForOffset];
				
			}
			
			if ([self hasOrderField] && [self hasOrderDirection]) {
				
				parametersDictionary[@"order"] = [self stringForOrders];
				
			}
			
			if ([self hasPostParams]) {
				
				[parametersDictionary addEntriesFromDictionary:self.postParams];
				
			}
			
			break;
			
		case MHRequestOptionsTypeCreate:
		case MHRequestOptionsTypeUpdate:
			
			if ([self hasIncludes]) {
				
				parametersDictionary[@"include"] = [self stringForIncludes];
				
			}
			
			if (self.jsonObject) {
				
				parametersDictionary[ [self stringInSingluarFormatForEndpoint] ] = self.jsonObject;
				
			}
			
			if ([self hasPostParams]) {
				
				[parametersDictionary addEntriesFromDictionary:self.postParams];
				
			}
			
			break;
			
		case MHRequestOptionsTypeBulkArchive:
		case MHRequestOptionsTypeBulkCreate:
		case MHRequestOptionsTypeBulkDelete:
		case MHRequestOptionsTypeBulk:
			
			if ([self hasFilters]) {
				
				__block NSMutableDictionary *filterDictionary = [NSMutableDictionary dictionary];
				[self.filters enumerateKeysAndObjectsUsingBlock:^(NSString *filter, NSString *value, BOOL *stop) {
					
					filterDictionary[filter]		= value;
					
				}];
				
				parametersDictionary[@"filters"]	= filterDictionary;
				
			}
			
			if ([self hasIncludes]) {
				
				parametersDictionary[@"include"] = [self stringForIncludes];
				
			}
			
			if ([self hasPostParams]) {
				
				[parametersDictionary addEntriesFromDictionary:self.postParams];
				
			}
			
			break;
			
		case MHRequestOptionsTypeBulkUpdate:
			
			if ([self hasFilters]) {
				
				__block NSMutableDictionary *filterDictionary = [NSMutableDictionary dictionary];
				[self.filters enumerateKeysAndObjectsUsingBlock:^(NSString *filter, NSString *value, BOOL *stop) {
					
					filterDictionary[filter]		= value;
					
				}];
				
				parametersDictionary[@"filters"]	= filterDictionary;
				
			}
			
			if ([self hasIncludes]) {
				
				parametersDictionary[@"include"] = [self stringForIncludes];
				
			}
			
			if ([self hasPostParams]) {
				
				[parametersDictionary addEntriesFromDictionary:self.postParams];
				
			}
		
			if (self.jsonObject) {
				
				parametersDictionary[ [self stringForEndpoint] ] = self.jsonObject;
				
			}
			
			break;
			
		default:
			break;
	}
	
	return parametersDictionary;
	
}

- (BOOL)hasRemoteID {
	return (self.remoteID > 0);
}

- (BOOL)hasFilters {
	return ([self.filters count] > 0);
}

- (BOOL)hasIncludes {
	return ([self.includes count] > 0);
}

- (BOOL)hasLimit {
	return (self.limit > 0);
}

- (BOOL)hasOffset {
	return (self.offset > 0);
}

- (BOOL)hasOrderField {
	return (self.orderField != MHRequestOptionsOrderFieldNone);
}

- (BOOL)hasOrderDirection {
	return (self.orderDirection != MHRequestOptionsOrderDirectionNone);
}

- (BOOL)hasPostParams {
	return ([self.postParams count] > 0);
}

- (instancetype)configureForInitialPeoplePageRequest {
	
	[[[self reset] addIncludesForPeoplePageRequest] setLimitAndOffsetForFirstPage];
	
	return self;
}

- (instancetype)configureForInitialPeoplePageRequestWithAssignedToID:(NSNumber *)remoteAssignedToID {
	
	[[[[self reset] addIncludesForPeoplePageRequest] setLimitAndOffsetForFirstPage] addFilter:MHRequestOptionsFilterPeopleAssignedTo withValue:[remoteAssignedToID stringValue]];
	
	return self;
}

- (instancetype)configureForCreatePersonRequestWithPerson:(MHPerson *)person {
	
	[[self reset] setEndpoint:MHRequestOptionsEndpointPeople];
	self.type		= MHRequestOptionsTypeCreate;
	self.jsonObject	= [person jsonObject];
	
	if (person.permissionLevel && [person.permissionLevel.permission_id integerValue] > 0) {
		
		[self addPostParam:@"permissions" withValue:[person.permissionLevel.permission_id stringValue]];
		
	}
	
	return self;
}

- (instancetype)configureForCreateInteractionRequestWithInteraction:(MHInteraction *)interaction {
	
	[[self reset] setEndpoint:MHRequestOptionsEndpointInteractions];
	self.type		= MHRequestOptionsTypeCreate;
	self.jsonObject	= [interaction jsonObject];
	
	return self;
}

- (instancetype)configureForMeRequest {
	
	[[self reset] addIncludesForMeRequest];
	self.type = MHRequestOptionsTypeMe;
	
	return self;
}

- (instancetype)configureForOrganizationRequestWithRemoteID:(NSNumber *)remoteID {
	
	[[self reset] addIncludesForOrganizationRequest];
	self.endpoint	= MHRequestOptionsEndpointOrganizations;
	self.remoteID	= remoteID.integerValue;
	self.type		= MHRequestOptionsTypeShow;
	[self addPostParam:@"organization_id" withValue:remoteID];
	
	return self;
}

- (instancetype)configureForProfileRequestWithRemoteID:(NSNumber *)remoteID {
	
	[[self reset] addIncludesForProfileRequest];
	self.remoteID	= remoteID.integerValue;
	self.type		= MHRequestOptionsTypeShow;
	
	return self;
}

- (instancetype)configureForInteractionRequestForPersonWithRemoteID:(NSNumber *)personID {
	
	[[[self reset] addIncludesForInteractionsRequest] addFilter:MHRequestOptionsFilterInteractionsPeopleIds withValue:[personID stringValue]];
	self.endpoint = MHRequestOptionsEndpointInteractions;
	
	return self;
}

- (instancetype)configureForSurveyAnswerSheetsRequestForPersonWithRemoteID:(NSNumber *)personID {
	
	[[[self reset] addInclude:MHRequestOptionsIncludePeopleAnswerSheets] addInclude:MHRequestOptionsIncludeAnswerSheetsAnswers];
	self.endpoint	= MHRequestOptionsEndpointPeople;
	self.remoteID	= [personID integerValue];
	self.type		= MHRequestOptionsTypeShow;
	
	return self;
}

- (NSString *)idStringFromPeopleArray:(NSArray *)people {
	
	NSArray *peopleArray				= ( people ? people : @[] );
	__block NSMutableString *idString	= [NSMutableString string];
	
	[peopleArray enumerateObjectsUsingBlock:^(id personObject, NSUInteger index, BOOL *stop) {
		
		if ([personObject isKindOfClass:[MHPerson class]]) {
			
			[idString appendFormat:@"%@,", ((MHPerson *)personObject).remoteID];
			
		}
		
	}];
	
	//remove trailing comma
	if (idString.length > 0) {
		[idString deleteCharactersInRange:NSMakeRange(idString.length - 1, 1)];
	}
	
	return idString;
	
}

- (NSString *)idStringFromLabelArray:(NSArray *)labels {
	
	NSArray *array				= ( labels ? labels : @[] );
	__block NSMutableString *idString	= [NSMutableString string];
	
	[array enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		if ([object isKindOfClass:[MHLabel class]]) {
			
			[idString appendFormat:@"%@,", ((MHLabel *)object).remoteID];
			
		}
		
	}];
	
	//remove trailing comma
	if (idString.length > 0) {
		[idString deleteCharactersInRange:NSMakeRange(idString.length - 1, 1)];
	}
	
	return idString;
	
}

- (instancetype)configureForBulkDeleteRequestForPeople:(NSArray *)people {
	
	NSString *idString	= [self idStringFromPeopleArray:people];
	
	[[self reset] addFilter:MHRequestOptionsFilterPeopleIds withValue:idString];
	self.type			= MHRequestOptionsTypeBulkDelete;
	self.endpoint		= MHRequestOptionsEndpointPeople;
	
	return self;
}

- (instancetype)configureForBulkArchiveRequestForPeople:(NSArray *)people {
	
	NSString *idString	= [self idStringFromPeopleArray:people];
	
	[[self reset] addFilter:MHRequestOptionsFilterPeopleIds withValue:idString];
	self.type			= MHRequestOptionsTypeBulkArchive;
	self.endpoint		= MHRequestOptionsEndpointPeople;
	
	return self;
}

- (instancetype)configureForBulkPermissionLevelRequestWithNewPermissionLevel:(MHPermissionLevel *)permissionLevel forPeople:(NSArray *)people {
	
	NSString *idString				= [self idStringFromPeopleArray:people];
	NSString *newPermissionIdString	= [NSString stringWithFormat:@"%@", permissionLevel.remoteID];
	
	[[self reset] addFilter:MHRequestOptionsFilterPeopleIds withValue:idString];
	self.type						= MHRequestOptionsTypeBulk;
	self.endpoint					= MHRequestOptionsEndpointOrganizationalPermissions;
	
	if (newPermissionIdString.length > 0) {
		[self addPostParam:@"add_permission" withValue:newPermissionIdString];
	}
	
	return self;
}

- (instancetype)configureForBulkStatusRequestWithNewStatus:(NSString *)status forPeople:(NSArray *)people {
	
	NSString *idString				= [self idStringFromPeopleArray:people];
	
	[[self reset] addFilter:MHRequestOptionsFilterPeopleIds withValue:idString];
	self.type						= MHRequestOptionsTypeBulk;
	self.endpoint					= MHRequestOptionsEndpointOrganizationalPermissions;
	
	if (status.length > 0) {
		[self addPostParam:@"followup_status" withValue:status];
	}
	
	return self;
}

- (instancetype)configureForBulkAssignmentRequestWithLeader:(MHPerson *)person forPeople:(NSArray *)people {
	
	if (person) {
	
		__block NSMutableArray	*contactAssignmentArray	= [NSMutableArray array];
		NSArray					*array					= ( people ? people : @[] );
		
		[array enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			if ([object isKindOfClass:[MHPerson class]]) {
				
				//TODO: create a model for contact assignments and use model
				MHContactAssignment *contactAssignment = [MHContactAssignment newObjectFromFields:@{
										@"person_id"		: ((MHPerson *)object).remoteID,
										@"assigned_to_id"	: person.remoteID
				}];
				
				[contactAssignmentArray addObject:contactAssignment.jsonObject];
				
			}
			
		}];
		
		[self reset];
		self.type		= MHRequestOptionsTypeBulkUpdate;
		self.endpoint	= MHRequestOptionsEndpointContactAssignments;
		self.jsonObject	= contactAssignmentArray;
		
	}
	
	return self;
}

- (instancetype)configureForBulkLabelingRequestWithLabelsToAdd:(NSArray *)labelsToAdd labelsToRemove:(NSArray *)labelsToRemove forPeople:(NSArray *)people {
	
	NSString *idString				= [self idStringFromPeopleArray:people];
	NSString *addLabelIdString		= [self idStringFromLabelArray:labelsToAdd];
	NSString *removeLabelIdString	= [self idStringFromLabelArray:labelsToRemove];
	
	
	[[self reset] addFilter:MHRequestOptionsFilterPeopleIds withValue:idString];
	self.type						= MHRequestOptionsTypeBulk;
	self.endpoint					= MHRequestOptionsEndpointOrganizationalLabels;
	
	if (addLabelIdString.length > 0) {
		[self addPostParam:@"add_labels" withValue:addLabelIdString];
	}
	
	if (removeLabelIdString.length > 0) {
		[self addPostParam:@"remove_labels" withValue:removeLabelIdString];
	}
	
	return self;
}

- (instancetype)configureForNextPageRequest {
	
	[self setLimitAndOffsetForNextPage];
	
	return self;
}

- (instancetype)addInclude:(MHRequestOptionsIncludes)include {
	
	[self.includes addIndex:include];
	
	return self;
	
}

- (instancetype)addIncludesForInteractionsRequest {
	
	[self addInclude:MHRequestOptionsIncludeInteractionsReceiver];
	[self addInclude:MHRequestOptionsIncludeInteractionsCreator];
	[self addInclude:MHRequestOptionsIncludeInteractionsInitiators];
	[self addInclude:MHRequestOptionsIncludeInteractionsInteractionType];
	[self addInclude:MHRequestOptionsIncludeInteractionsLastUpdater];
	
	return self;
}

- (instancetype)addIncludesForProfileRequest {
	
	
	//[self addInclude:MHRequestOptionsIncludePeopleInteractions];
	[self addInclude:MHRequestOptionsIncludePeopleOrganizationalPermissions];
	[self addInclude:MHRequestOptionsIncludeOrganizationalPermissionsPermission];
	[self addInclude:MHRequestOptionsIncludePeopleOrganizationalLabels];
	[self addInclude:MHRequestOptionsIncludeOrganizationalLabelsLabel];
	[self addInclude:MHRequestOptionsIncludePeopleEmailAddresses];
	[self addInclude:MHRequestOptionsIncludePeoplePhoneNumbers];
	[self addInclude:MHRequestOptionsIncludePeopleAddresses];
	
	
	return self;
}

- (instancetype)addIncludesForPeoplePageRequest {
	
	
	[self addInclude:MHRequestOptionsIncludePeopleOrganizationalPermissions];
	[self addInclude:MHRequestOptionsIncludePeopleOrganizationalLabels];
	[self addInclude:MHRequestOptionsIncludePeopleEmailAddresses];
	[self addInclude:MHRequestOptionsIncludePeoplePhoneNumbers];
	[self addInclude:MHRequestOptionsIncludePeopleAddresses];
	
	
	return self;
}

- (instancetype)addIncludesForContactAssignmentsPageRequest {
	
	[self addInclude:MHRequestOptionsIncludeConactAssignmentsPerson];
	
	return self;
	
}

- (instancetype)addIncludesForOrganizationRequest {
	
	[self addInclude:MHRequestOptionsIncludeOrganizationsAdmins];
	[self addInclude:MHRequestOptionsIncludeOrganizationsUsers];
	[self addInclude:MHRequestOptionsIncludeOrganizationsSurveys];
	[self addInclude:MHRequestOptionsIncludeOrganizationsLabels];
	[self addInclude:MHRequestOptionsIncludeOrganizationsAllQuestions];
	[self addInclude:MHRequestOptionsIncludeOrganizationsInteractionTypes];
	
	return self;
}

- (instancetype)addIncludesForMeRequest {
	
	[self addIncludesForProfileRequest];
	[self addInclude:MHRequestOptionsIncludePeopleAllOrganizationsAndChildren];
	[self addInclude:MHRequestOptionsIncludePeopleAllOrganizationalPermissions];
	[self addInclude:MHRequestOptionsIncludePeopleUser];
	
	return self;
}

- (instancetype)resetPaging {
	
	return [self setLimitAndOffsetForFirstPage];
	
}

- (instancetype)setLimitAndOffsetForFirstPage {
	
	self.offset = 0;
	
	[self setLimitForScreenDimensions];
	
	return self;
}

- (instancetype)setLimitAndOffsetForNextPage {
	
	self.offset += self.limit;
	
	[self setLimitForScreenDimensions];
	
	return self;
}

- (instancetype)setLimitForScreenDimensions {
	
	if (isPad) {
		
		if (isPortrait) {
			
			self.limit = 40;
			
		} else {
			
			self.limit = 30;
			
		}
		
	} else {
		
		if (isPortrait) {
			
			self.limit = 30;
			
		} else {
			
			self.limit = 20;
			
		}
		
	}
	
	return self;
	
}

- (instancetype)clearIncludes {
	
	[self.includes removeAllIndexes];
	
	return self;
}

- (instancetype)setOrderField:(MHRequestOptionsOrderFields)orderField orderDirection:(MHRequestOptionsOrderDirections)orderDirection {
	
	self.orderField		= orderField;
	self.orderDirection = orderDirection;
	
	return self;
	
}

- (instancetype)clearOrders {
	
	self.orderField		= MHRequestOptionsOrderFieldNone;
	self.orderDirection = MHRequestOptionsOrderDirectionNone;
	
	return self;
}

- (instancetype)addPostParam:(NSString *)paramName withValue:(id <NSObject>)value {
	
	[self.postParams setObject:value forKey:paramName];
	
	return self;
}

- (instancetype)updatePostParam:(NSString *)paramName withValue:(id <NSObject>)value {
	
	[self.postParams setObject:value forKey:paramName];
	
	return self;
}

- (instancetype)removePostParam:(NSString *)paramName {
	
	[self.postParams removeObjectForKey:paramName];
	
	return self;
}

- (instancetype)clearPostParams {
	
	[self.postParams removeAllObjects];
	
	return self;
}

- (instancetype)addFilter:(MHRequestOptionsFilters)filter withValue:(NSString *)value {
	
	[self.filters setObject:value forKey:[self stringFromFilter:filter]];
	
	return self;
}

- (instancetype)updateFilter:(MHRequestOptionsFilters)filter withValue:(NSString *)value {
	
	[self.filters setValue:value forKey:[self stringFromFilter:filter]];
	
	return self;
}

- (instancetype)removeFilter:(MHRequestOptionsFilters)filter {
	
	[self.filters removeObjectForKey:[self stringFromFilter:filter]];
	
	return self;
}

- (instancetype)clearFilters {
	
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
	
	__weak __typeof(&*self)weakSelf = self;
	[self.includes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
		
		MHRequestOptionsIncludes include	= (MHRequestOptionsIncludes)index;
		includeString = [includeString stringByAppendingFormat:@"%@,", [weakSelf stringFromInclude:include]];
		
	}];
	
	//remove last comma from the end of the string
	includeString = [includeString substringToIndex:[includeString length] - 1];
	
	return includeString;
}

-(NSString *)stringForFilters {
	
	__block NSString * filterString = @"";
	
	[self.filters enumerateKeysAndObjectsUsingBlock:^(NSString *filter, NSString *value, BOOL *stop) {
		
		filterString = [filterString stringByAppendingFormat:@"&filters[%@]=%@", filter, [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		
	}];
	
	return filterString;
	
}

-(NSString *)stringForLimit {
	return [NSNumber numberWithInteger:self.limit].stringValue;
}

-(NSString *)stringForOffset {
	return [NSNumber numberWithInteger:self.offset].stringValue;
}

-(NSString *)stringForOrders {
	
	__block NSString * orderString = [NSString stringWithFormat:@"%@ %@", [self stringFromOrderField:self.orderField], [self stringFromOrderDirection:self.orderDirection]];
	
	return orderString;
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

-(NSString *)classNameForEndpoint {
	
	return [self classNameFromEndpoint:self.endpoint];
	
}

-(NSString *)classNameFromEndpoint:(MHRequestOptionsEndpoints)endpoint {
	
	NSString *endpointString;
	
	switch (endpoint) {
		case MHRequestOptionsEndpointAnswers:
			endpointString = @"MHAnswer";
			break;
		case MHRequestOptionsEndpointContactAssignments:
			endpointString = @"MHContactAssignment";
			break;
		case MHRequestOptionsEndpointInteractions:
			endpointString = @"MHInteraction";
			break;
		case MHRequestOptionsEndpointInteractionTypes:
			endpointString = @"MHInteractionType";
			break;
		case MHRequestOptionsEndpointLabels:
			endpointString = @"MHLabel";
			break;
		case MHRequestOptionsEndpointOrganizationalLabels:
			endpointString = @"MHOrganizationalLabel";
			break;
		case MHRequestOptionsEndpointOrganizationalPermissions:
			endpointString = @"MHOrganizationalPermission";
			break;
		case MHRequestOptionsEndpointOrganizations:
			endpointString = @"MHOrganization";
			break;
		case MHRequestOptionsEndpointPeople:
			endpointString = @"MHPerson";
			break;
		case MHRequestOptionsEndpointPermissions:
			endpointString = @"MHPermission";
			break;
		case MHRequestOptionsEndpointQuestions:
			endpointString = @"MHQuestion";
			break;
		case MHRequestOptionsEndpointSurveys:
			endpointString = @"MHSurvey";
			break;
			
		default:
			endpointString = @"MHModel";
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
		case MHRequestOptionsFilterContactAssignmentsAssignedToId:
			filterString = @"assigned_to_id";
			break;
		case MHRequestOptionsFilterContactAssignmentsIds:
			filterString = @"ids";
			break;
		case MHRequestOptionsFilterContactAssignmentsPersonId:
			filterString = @"person_id";
			break;
		case MHRequestOptionsFilterPeopleAssignedTo:
			filterString = @"assigned_to";
			break;
		case MHRequestOptionsFilterPeopleFollowupStatus:
			filterString = @"followup_status";
			break;
		case MHRequestOptionsFilterPeopleGender:
			filterString = @"gender";
			break;
		case MHRequestOptionsFilterPeopleIds:
			filterString = @"ids";
			break;
		case MHRequestOptionsFilterPeopleInteractions:
			filterString = @"interactions";
			break;
		case MHRequestOptionsFilterInteractionsPeopleIds:
			filterString = @"people_ids";
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
		case MHRequestOptionsIncludeOrganizationsLabels:
			includeString = @"labels";
			break;
		case MHRequestOptionsIncludeOrganizationsInteractionTypes:
			includeString = @"interaction_types";
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
			includeString = @"organizational_permission";
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
		case MHRequestOptionsIncludeAnswerSheetsAnswers:
			includeString = @"answers";
			break;
			
		default:
			break;
	}
	
	return includeString;
	
}

-(NSString *)stringFromOrderField:(MHRequestOptionsOrderFields)orderField {

	NSString *orderString;
	
	switch (orderField) {
		case MHRequestOptionsOrderFieldCreatedAt:
			orderString = @"created_at";
			break;
		case MHRequestOptionsOrderFieldPeopleFirstName:
			orderString = @"first_name";
			break;
		case MHRequestOptionsOrderFieldPeopleFollowupStatus:
			orderString = @"followup_status";
			break;
		case MHRequestOptionsOrderFieldPeopleGender:
			orderString = @"gender";
			break;
		case MHRequestOptionsOrderFieldPeopleLastName:
			orderString = @"last_name";
			break;
		case MHRequestOptionsOrderFieldPeoplePermission:
			orderString = @"permission";
			break;
		case MHRequestOptionsOrderFieldPeoplePrimaryEmail:
			orderString = @"primary_email";
			break;
		case MHRequestOptionsOrderFieldPeoplePrimaryPhone:
			orderString = @"primary_phone";
			break;
		default:
			break;
	}
	
	return orderString;
	
}

-(NSString *)stringFromOrderDirection:(MHRequestOptionsOrderDirections)orderDirection {
	
	NSString *orderString;
	
	switch (orderDirection) {
		case MHRequestOptionsOrderDirectionAsc:
			orderString = @"asc";
			break;
		case MHRequestOptionsOrderDirectionDesc:
			orderString = @"desc";
			break;
		default:
			break;
	}
	
	return orderString;
	
}

@end
