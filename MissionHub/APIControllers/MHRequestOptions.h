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
	MHRequestOptionsIncludePeoplePeopleOrganizationalLabels,
	MHRequestOptionsIncludePeoplePeopleAnswerSheets,
	MHRequestOptionsIncludePeopleEmailAddresses,
	MHRequestOptionsIncludePeoplePhoneNumbers,
	MHRequestOptionsIncludePeopleInteractions,
	MHRequestOptionsIncludePeopleAllOrganizationalPermissions,
	MHRequestOptionsIncludePeopleAllOrganizationsAndChildren,
	MHRequestOptionsIncludePeoplePersonTransfers,
	MHRequestOptionsIncludeConactAssignmentsAssignedTo,
	MHRequestOptionsIncludeConactAssignmentsPerson,
	MHRequestOptionsIncludeSurveysQuestions,
	MHRequestOptionsIncludeSurveysKeywords
} MHRequestOptionsIncludes;

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
	NSMutableIndexSet			*_includes;
	NSUInteger					_limit;
	NSUInteger					_offset;
	MHRequestOptionsOrders		_order;
	
}

@property (nonatomic, assign) MHRequestOptionsEndpoints	endpoint;
@property (nonatomic, assign) NSUInteger				remoteID;
@property (nonatomic, strong) NSMutableIndexSet			*includes;
@property (nonatomic, assign) NSUInteger				limit;
@property (nonatomic, assign) NSUInteger				offset;
@property (nonatomic, assign) MHRequestOptionsOrders	order;

-(BOOL)hasRemoteID;
-(BOOL)hasIncludes;
-(BOOL)hasLimit;
-(BOOL)hasOffset;
-(BOOL)hasOrder;

-(NSString *)stringForEndpoint;
-(NSString *)stringInSingluarFormatForEndpoint;
-(NSString *)stringForIncludes;
-(NSString *)stringForLimit;
-(NSString *)stringForOffset;
-(NSString *)stringForOrder;

-(NSString *)stringFromEndpoint:(MHRequestOptionsEndpoints)endpoint;
-(NSString *)stringInSingluarFormatFromEndpoint:(MHRequestOptionsEndpoints)endpoint;
-(NSString *)stringFromInclude:(MHRequestOptionsIncludes)include;
-(NSString *)stringFromOrder:(MHRequestOptionsOrders)order;

@end
