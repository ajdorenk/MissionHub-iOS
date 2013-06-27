//
//  MHRequestOptions.h
//  MissionHub
//
//  Created by Michael Harrison on 6/19/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>

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
	MHRequestOptionsIncludeOrganizationsSurveys,
	MHRequestOptionsIncludeOrganizationsKeywords,
	MHRequestOptionsIncludePeopleContactAssignments,
	MHRequestOptionsIncludePeopleAssignTos,
	MHRequestOptionsIncludePeopleOrganizationalPermissions,
	MHRequestOptionsIncludePeopleOrganizationalLabels,
	MHRequestOptionsIncludePeopleAnswerSheets,
	MHRequestOptionsIncludePeopleEmailAddresses,
	MHRequestOptionsIncludePeoplePhoneNumbers,
	MHRequestOptionsIncludePeopleCurrentAddress,
	MHRequestOptionsIncludePeopleInteractions,
	MHRequestOptionsIncludePeopleAllOrganizationalPermissions,
	MHRequestOptionsIncludePeopleAllOrganizationsAndChildren,
	MHRequestOptionsIncludePeoplePersonTransfers,
	MHRequestOptionsIncludePeopleAllQuestions,
	MHRequestOptionsIncludeConactAssignmentsAssignedTo,
	MHRequestOptionsIncludeConactAssignmentsPerson,
	MHRequestOptionsIncludeSurveysQuestions,
	MHRequestOptionsIncludeSurveysKeywords,
	MHRequestOptionsIncludeOrganizationalLabelsLabel,
	MHRequestOptionsIncludeOrganizationalPermissionsPermission
} MHRequestOptionsIncludes;

typedef enum {
	MHRequestOptionsFilterPeopleLabels,
	MHRequestOptionsFilterPeoplePermissions,
	MHRequestOptionsFilterPeopleRoles,
	MHRequestOptionsFilterPeopleSurveys,
	MHRequestOptionsFilterPeopleFirstNameLike,
	MHRequestOptionsFilterPeopleLastNameLike,
	MHRequestOptionsFilterPeopleNameLike,
	MHRequestOptionsFilterPeopleEmailLike,
	MHRequestOptionsFilterPeopleNameOrEmailLike
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
	
	MHRequestOptionsEndpoints	_endpoint;
	NSUInteger					_remoteID;
	NSMutableDictionary			*_filters;
	NSMutableIndexSet			*_includes;
	NSUInteger					_limit;
	NSUInteger					_offset;
	MHRequestOptionsOrders		_order;
	
}

@property (nonatomic, assign) MHRequestOptionsEndpoints	endpoint;
@property (nonatomic, assign) NSUInteger				remoteID;
@property (nonatomic, strong) NSMutableDictionary		*filters;
@property (nonatomic, strong) NSMutableIndexSet			*includes;
@property (nonatomic, assign) NSUInteger				limit;
@property (nonatomic, assign) NSUInteger				offset;
@property (nonatomic, assign) MHRequestOptionsOrders	order;

-(BOOL)hasRemoteID;
-(BOOL)hasFilters;
-(BOOL)hasIncludes;
-(BOOL)hasLimit;
-(BOOL)hasOffset;
-(BOOL)hasOrder;

-(void)addInclude:(MHRequestOptionsIncludes)include;
-(void)addIncludesForProfileRequest;
-(void)addIncludesForOrganizationRequest;
-(void)addIncludesForMeRequest;
-(void)clearIncludes;
-(void)addFilter:(MHRequestOptionsFilters)filter withValue:(NSString *)value;
-(void)updateFilter:(MHRequestOptionsFilters)filter withValue:(NSString *)value;
-(void)removeFilter:(MHRequestOptionsFilters)filter;
-(void)clearFilters;

-(NSString *)stringForEndpoint;
-(NSString *)stringInSingluarFormatForEndpoint;
-(NSString *)stringForFilters;
-(NSString *)stringForIncludes;
-(NSString *)stringForLimit;
-(NSString *)stringForOffset;
-(NSString *)stringForOrder;

-(NSString *)stringFromEndpoint:(MHRequestOptionsEndpoints)endpoint;
-(NSString *)stringFromFilter:(MHRequestOptionsFilters)filter;
-(NSString *)stringInSingluarFormatFromEndpoint:(MHRequestOptionsEndpoints)endpoint;
-(NSString *)stringFromInclude:(MHRequestOptionsIncludes)include;
-(NSString *)stringFromOrder:(MHRequestOptionsOrders)order;

@end
