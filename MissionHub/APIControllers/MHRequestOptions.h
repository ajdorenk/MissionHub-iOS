//
//  MHRequestOptions.h
//  MissionHub
//
//  Created by Michael Harrison on 6/19/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	MHRequestOptionsTypeShow,
	MHRequestOptionsTypeIndex,
	MHRequestOptionsTypeCreate,
	MHRequestOptionsTypeUpdate,
	MHRequestOptionsTypeDelete
} MHRequestOptionsTypes;

typedef enum {
	MHRequestOptionsEndpointOrganizations,
	MHRequestOptionsEndpointPeople,
	MHRequestOptionsEndpointOrganizationalLabels,
	MHRequestOptionsEndpointLabels,
	MHRequestOptionsEndpointOrganizationalPermissions,
	MHRequestOptionsEndpointPermissions,
	MHRequestOptionsEndpointInteractions,
	MHRequestOptionsEndpointInteractionTypes,
	MHRequestOptionsEndpointContactAssignments,
	MHRequestOptionsEndpointSurveys,
	MHRequestOptionsEndpointQuestions,
	MHRequestOptionsEndpointAnswers
} MHRequestOptionsEndpoints;

typedef enum {
	MHRequestOptionsIncludeOrganizationsAdmins,
	MHRequestOptionsIncludeOrganizationsUsers,
	MHRequestOptionsIncludeOrganizationsNoPermissions,
	MHRequestOptionsIncludeOrganizationsPeople,
	MHRequestOptionsIncludeOrganizationsLabels,
	MHRequestOptionsIncludeOrganizationsSurveys,
	MHRequestOptionsIncludeOrganizationsAllQuestions,
	MHRequestOptionsIncludeOrganizationsKeywords,
	MHRequestOptionsIncludePeopleContactAssignments,
	MHRequestOptionsIncludePeopleAssignTos,
	MHRequestOptionsIncludePeopleOrganizationalPermissions,
	MHRequestOptionsIncludePeopleOrganizationalLabels,
	MHRequestOptionsIncludePeopleAnswerSheets,
	MHRequestOptionsIncludePeopleEmailAddresses,
	MHRequestOptionsIncludePeoplePhoneNumbers,
	MHRequestOptionsIncludePeopleAddresses,
	MHRequestOptionsIncludePeopleInteractions,
	MHRequestOptionsIncludePeopleAllOrganizationalPermissions,
	MHRequestOptionsIncludePeopleAllOrganizationsAndChildren,
	MHRequestOptionsIncludePeoplePersonTransfers,
	MHRequestOptionsIncludePeopleUser,
	MHRequestOptionsIncludeInteractionsInitiators,
	MHRequestOptionsIncludeInteractionsInteractionType,
	MHRequestOptionsIncludeInteractionsReceiver,
	MHRequestOptionsIncludeInteractionsCreator,
	MHRequestOptionsIncludeInteractionsLastUpdater,
	MHRequestOptionsIncludeConactAssignmentsAssignedTo,
	MHRequestOptionsIncludeConactAssignmentsPerson,
	MHRequestOptionsIncludeSurveysQuestions,
	MHRequestOptionsIncludeSurveysKeywords,
	MHRequestOptionsIncludeOrganizationalLabelsLabel,
	MHRequestOptionsIncludeOrganizationalPermissionsPermission
} MHRequestOptionsIncludes;

typedef enum {
	MHRequestOptionsFilterPeopleIds,
	MHRequestOptionsFilterPeopleLabels,
	MHRequestOptionsFilterPeoplePermissions,
	MHRequestOptionsFilterPeopleRoles,
	MHRequestOptionsFilterPeopleInteractions,
	MHRequestOptionsFilterPeopleSurveys,
	MHRequestOptionsFilterPeopleFirstNameLike,
	MHRequestOptionsFilterPeopleLastNameLike,
	MHRequestOptionsFilterPeopleNameLike,
	MHRequestOptionsFilterPeopleEmailLike,
	MHRequestOptionsFilterPeopleNameOrEmailLike,
	MHRequestOptionsFilterPeopleGender,
	MHRequestOptionsFilterPeopleFollowupStatus,
	MHRequestOptionsFilterPeopleAssignedTo,
	MHRequestOptionsFilterInteractionsPeopleIds,
	MHRequestOptionsFilterContactAssignmentsIds,
	MHRequestOptionsFilterContactAssignmentsAssignedToId,
	MHRequestOptionsFilterContactAssignmentsPersonId
} MHRequestOptionsFilters;

typedef enum {
	MHRequestOptionsOrderNone,
	MHRequestOptionsOrderCreatedAt,
	MHRequestOptionsOrderAsc,
	MHRequestOptionsOrderDesc,
	MHRequestOptionsOrderPeopleFirstName,
	MHRequestOptionsOrderPeopleLastName
} MHRequestOptionsOrders;

@interface MHRequestOptions : NSObject {
	
	NSString					*_requestName;
	MHRequestOptionsTypes		_type;
	MHRequestOptionsEndpoints	_endpoint;
	NSUInteger					_remoteID;
	NSMutableDictionary			*_filters;
	NSMutableIndexSet			*_includes;
	NSUInteger					_limit;
	NSUInteger					_offset;
	MHRequestOptionsOrders		_order;
	
	NSMutableDictionary			*_postParams;
	
	void (^_successBlock)(NSArray *results, MHRequestOptions *options);
	void (^_failBlock)(NSError *error, MHRequestOptions *options);
	
}

@property (nonatomic, strong) NSString					*requestName;
@property (nonatomic, assign) MHRequestOptionsTypes		type;
@property (nonatomic, assign) MHRequestOptionsEndpoints	endpoint;
@property (nonatomic, assign) NSUInteger				remoteID;
@property (nonatomic, strong) NSMutableDictionary		*filters;
@property (nonatomic, strong) NSMutableIndexSet			*includes;
@property (nonatomic, assign) NSUInteger				limit;
@property (nonatomic, assign) NSUInteger				offset;
@property (nonatomic, assign) MHRequestOptionsOrders	order;

@property (nonatomic, strong) NSMutableDictionary		*postParams;

@property (nonatomic, strong) void (^successBlock)(NSArray *results, MHRequestOptions *options);
@property (nonatomic, strong) void (^failBlock)(NSError *error, MHRequestOptions *options);


-(BOOL)hasRemoteID;
-(BOOL)hasFilters;
-(BOOL)hasIncludes;
-(BOOL)hasLimit;
-(BOOL)hasOffset;
-(BOOL)hasOrder;

-(id)configureForInitialPeoplePageRequest;
-(id)configureForInitialPeoplePageRequestWithAssignedToID:(NSNumber *)remoteAssignedToID;
//-(id)configureForInitialContactAssignmentsPageRequestWithAssignedToID:(NSNumber *)remoteAssignedToID;
-(id)configureForMeRequest;
-(id)configureForOrganizationRequestWithRemoteID:(NSNumber *)remoteID;
-(id)configureForNextPageRequest;
-(id)configureForProfileRequestWithRemoteID:(NSNumber *)personID;
-(id)configureForInteractionRequestForPersonWithRemoteID:(NSNumber *)personID;

-(id)addInclude:(MHRequestOptionsIncludes)include;
-(id)addIncludesForProfileRequest;
-(id)addIncludesForOrganizationRequest;
-(id)addIncludesForMeRequest;
-(id)addIncludesForPeoplePageRequest;
-(id)addIncludesForContactAssignmentsPageRequest;
-(id)clearIncludes;

-(id)setLimitAndOffsetForFirstPage;
-(id)setLimitAndOffsetForNextPage;
-(id)resetPaging;

-(id)addPostParam:(NSString *)paramName withValue:(id <NSObject>)value;
-(id)updatePostParam:(NSString *)paramName withValue:(id <NSObject>)value;
-(id)removePostParam:(NSString *)paramName;
-(id)clearPostParams;

-(id)addFilter:(MHRequestOptionsFilters)filter withValue:(NSString *)value;
-(id)updateFilter:(MHRequestOptionsFilters)filter withValue:(NSString *)value;
-(id)removeFilter:(MHRequestOptionsFilters)filter;
-(id)clearFilters;

-(id)reset;

-(NSString *)stringForEndpoint;
-(NSString *)stringInSingluarFormatForEndpoint;
-(NSString *)stringForFilters;
-(NSString *)stringForIncludes;
-(NSString *)stringForLimit;
-(NSString *)stringForOffset;
-(NSString *)stringForOrder;
-(NSString *)classNameForEndpoint;

-(NSString *)classNameFromEndpoint:(MHRequestOptionsEndpoints)endpoint;
-(NSString *)stringFromEndpoint:(MHRequestOptionsEndpoints)endpoint;
-(NSString *)stringFromFilter:(MHRequestOptionsFilters)filter;
-(NSString *)stringInSingluarFormatFromEndpoint:(MHRequestOptionsEndpoints)endpoint;
-(NSString *)stringFromInclude:(MHRequestOptionsIncludes)include;
-(NSString *)stringFromOrder:(MHRequestOptionsOrders)order;

@end
