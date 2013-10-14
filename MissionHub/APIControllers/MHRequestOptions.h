//
//  MHRequestOptions.h
//  MissionHub
//
//  Created by Michael Harrison on 6/19/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHPerson+Helper.h"
#import "MHInteraction+Helper.h"
#import "MHOrganizationalLabel+Helper.h"
#import "MHPermissionLevel+Helper.h"

typedef enum {
	MHRequestOptionsTypeMe,
	MHRequestOptionsTypeShow,
	MHRequestOptionsTypeIndex,
	MHRequestOptionsTypeCreate,
	MHRequestOptionsTypeUpdate,
	MHRequestOptionsTypeDelete,
	MHRequestOptionsTypeBulk,
	MHRequestOptionsTypeBulkCreate,
	MHRequestOptionsTypeBulkUpdate,
	MHRequestOptionsTypeBulkArchive,
	MHRequestOptionsTypeBulkDelete
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
	MHRequestOptionsIncludeOrganizationsInteractionTypes,
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
	MHRequestOptionsIncludeOrganizationalPermissionsPermission,
	MHRequestOptionsIncludeAnswerSheetsAnswers,
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
	MHRequestOptionsOrderFieldNone,
	MHRequestOptionsOrderFieldCreatedAt,
	MHRequestOptionsOrderFieldPeopleFirstName,
	MHRequestOptionsOrderFieldPeopleLastName,
	MHRequestOptionsOrderFieldPeopleGender,
	MHRequestOptionsOrderFieldPeopleFollowupStatus,
	MHRequestOptionsOrderFieldPeoplePermission,
	MHRequestOptionsOrderFieldPeoplePrimaryPhone,
	MHRequestOptionsOrderFieldPeoplePrimaryEmail
} MHRequestOptionsOrderFields;

typedef enum {
	MHRequestOptionsOrderDirectionNone,
	MHRequestOptionsOrderDirectionAsc,
	MHRequestOptionsOrderDirectionDesc
} MHRequestOptionsOrderDirections;

@interface MHRequestOptions : NSObject

@property (nonatomic, strong) NSString							*requestName;
@property (nonatomic, assign) MHRequestOptionsTypes				type;
@property (nonatomic, assign) MHRequestOptionsEndpoints			endpoint;
@property (nonatomic, assign) NSUInteger						remoteID;
@property (nonatomic, strong) NSMutableDictionary				*filters;
@property (nonatomic, strong) NSMutableIndexSet					*includes;
@property (nonatomic, assign) NSUInteger						limit;
@property (nonatomic, assign) NSUInteger						offset;
@property (nonatomic, assign) MHRequestOptionsOrderFields		orderField;
@property (nonatomic, assign) MHRequestOptionsOrderDirections	orderDirection;

@property (nonatomic, strong) NSMutableDictionary				*postParams;
@property (nonatomic, strong) id								jsonObject;

@property (nonatomic, strong) void (^successBlock)(NSArray *results, MHRequestOptions *options);
@property (nonatomic, strong) void (^failBlock)(NSError *error, MHRequestOptions *options);

- (NSString *)method;
- (NSString *)path;
- (NSMutableDictionary *)parameters;

- (instancetype)configureForInitialPeoplePageRequest;
- (instancetype)configureForInitialPeoplePageRequestWithAssignedToID:(NSNumber *)remoteAssignedToID;

- (instancetype)configureForMeRequest;
- (instancetype)configureForOrganizationRequestWithRemoteID:(NSNumber *)remoteID;
- (instancetype)configureForNextPageRequest;
- (instancetype)configureForProfileRequestWithRemoteID:(NSNumber *)personID;
- (instancetype)configureForInteractionRequestForPersonWithRemoteID:(NSNumber *)personID;
- (instancetype)configureForSurveyAnswerSheetsRequestForPersonWithRemoteID:(NSNumber *)personID;

- (instancetype)configureForCreateInteractionRequestWithInteraction:(MHInteraction *)interaction;
- (instancetype)configureForCreatePersonRequestWithPerson:(MHPerson *)person;

- (instancetype)configureForBulkDeleteRequestForPeople:(NSArray *)people;
- (instancetype)configureForBulkArchiveRequestForPeople:(NSArray *)people;
- (instancetype)configureForBulkPermissionLevelRequestWithNewPermissionLevel:(MHPermissionLevel *)permissionLevel forPeople:(NSArray *)people;
- (instancetype)configureForBulkAssignmentRequestWithLeader:(MHPerson *)person forPeople:(NSArray *)people;
- (instancetype)configureForBulkLabelingRequestWithLabelsToAdd:(NSArray *)labelsToAdd labelsToRemove:(NSArray *)labelsToRemove forPeople:(NSArray *)people;

- (instancetype)addInclude:(MHRequestOptionsIncludes)include;
- (instancetype)addIncludesForProfileRequest;
- (instancetype)addIncludesForOrganizationRequest;
- (instancetype)addIncludesForMeRequest;
- (instancetype)addIncludesForPeoplePageRequest;
- (instancetype)addIncludesForContactAssignmentsPageRequest;
- (instancetype)clearIncludes;

- (instancetype)setOrderField:(MHRequestOptionsOrderFields)orderField orderDirection:(MHRequestOptionsOrderDirections)orderDirection;
- (instancetype)clearOrders;

- (instancetype)setLimitAndOffsetForFirstPage;
- (instancetype)setLimitAndOffsetForNextPage;
- (instancetype)setLimitForScreenDimensions;
- (instancetype)resetPaging;

- (instancetype)addPostParam:(NSString *)paramName withValue:(id <NSObject>)value;
- (instancetype)updatePostParam:(NSString *)paramName withValue:(id <NSObject>)value;
- (instancetype)removePostParam:(NSString *)paramName;
- (instancetype)clearPostParams;

- (instancetype)addFilter:(MHRequestOptionsFilters)filter withValue:(NSString *)value;
- (instancetype)updateFilter:(MHRequestOptionsFilters)filter withValue:(NSString *)value;
- (instancetype)removeFilter:(MHRequestOptionsFilters)filter;
- (instancetype)clearFilters;

- (instancetype)reset;

- (NSString *)stringForEndpoint;
- (NSString *)stringInSingluarFormatForEndpoint;
- (NSString *)stringForFilters;
- (NSString *)stringForIncludes;
- (NSString *)stringForLimit;
- (NSString *)stringForOffset;
- (NSString *)stringForOrders;
- (NSString *)classNameForEndpoint;

- (NSString *)classNameFromEndpoint:(MHRequestOptionsEndpoints)endpoint;
- (NSString *)stringFromEndpoint:(MHRequestOptionsEndpoints)endpoint;
- (NSString *)stringFromFilter:(MHRequestOptionsFilters)filter;
- (NSString *)stringInSingluarFormatFromEndpoint:(MHRequestOptionsEndpoints)endpoint;
- (NSString *)stringFromInclude:(MHRequestOptionsIncludes)include;
- (NSString *)stringFromOrderField:(MHRequestOptionsOrderFields)orderField;
- (NSString *)stringFromOrderDirection:(MHRequestOptionsOrderDirections)orderDirection;

@end
