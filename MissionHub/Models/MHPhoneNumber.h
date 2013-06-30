//
//  MHPhoneNumber.h
//  MissionHub
//
//  Created by Michael Harrison on 6/29/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MHModel.h"

@class MHPerson;

@interface MHPhoneNumber : MHModel

@property (nonatomic, retain) NSNumber * created_at;
@property (nonatomic, retain) NSNumber * remoteID;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * primary;
@property (nonatomic, retain) NSString * txt_to_email;
@property (nonatomic, retain) NSDate * email_updated_at;
@property (nonatomic, retain) MHPerson *person;

@end
