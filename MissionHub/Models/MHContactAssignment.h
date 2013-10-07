//
//  MHContactAssignment.h
//  MissionHub
//
//  Created by Michael Harrison on 10/7/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MHModel.h"


@interface MHContactAssignment : MHModel

@property (nonatomic, retain) NSNumber * remoteID;
@property (nonatomic, retain) NSNumber * assigned_to_id;
@property (nonatomic, retain) NSNumber * person_id;
@property (nonatomic, retain) NSNumber * organization_id;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * updated_at;

@end
